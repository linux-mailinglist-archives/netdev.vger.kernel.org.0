Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BCE79C21
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 00:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfG2WCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 18:02:54 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45776 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfG2WCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 18:02:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id s22so45186522qkj.12
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 15:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Kp2ApHM2N6BPXTyZ8X+rutKsVrNVzep/5sS7niOLYf4=;
        b=ngxAJyYJLRVPjOpxF2sw7PM2pW0D42Acc7S22Q15YM7CEF3HoNT43Ko72akXRHCXJd
         wKPGUxLmE5iAtdWz426jrqQEuSbKPtPK0/upKaytee2vxZqG/yrHXWoeWWe3DSGH0z5+
         FdSTXcF9yk669i40haRxwPXhLtaJtyk5Q86z0aIPjmPdG/v+lk0XcQYGsIoJ9b5nDEyh
         +7D5lF6otLYLLbLl+4QiZxtONTo/g3c86THZMk+bUGBDYvgjK/1cxgcnWfnYFlFPRanq
         JBaYNslt08GfkF2jqdiAarxhAHUhHyAuNO8EBKr6uZUddIJOk2LfRCpLP9ok0mJj+W+E
         4Jag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Kp2ApHM2N6BPXTyZ8X+rutKsVrNVzep/5sS7niOLYf4=;
        b=V8kZPQgy2EcU4N5j1iVMdbI4bQFyesf9pSHGF+n4/YSvyHp7gBT6Z8cO5hcJGxfnNG
         3m5pfb4C5WS7SaJWo/MJ3j1X/3t9fR6tPa1/EPkZec1BcUNxdtl0rsQ8whgLANEbyh2a
         O6Q+VrBjJCPMEJsBQ1QwY0gNa5whsgn2pCAhacIgops0dEAorRaBoLwPTQZ32BSgfzFG
         VJ1QNA5i90+VSpXQR8NHFQl6R7m7rXPeXy2uXntJU8cuH5rmMl3zoUtpwqommaXLNka5
         sF3rEtzS9Bf/m3VJZkQp6h0XZqvSIG3WN273ibETAiQqMJ3APPUBq/lI92OxRaKmEoGp
         LwLA==
X-Gm-Message-State: APjAAAW6XKXSHwv6LStt93jRyHSjF52bsyfDnGTh2vbD2ys2t8U8IGvX
        blmCBpo6cJw2vKx9HaaclKFNKA==
X-Google-Smtp-Source: APXvYqzsu82lmQTRJADtB5YDseo2zKMtDStuIM715AFibFZSPFie85S+22AaJxu4HkIXrGtpruuyJA==
X-Received: by 2002:ae9:f107:: with SMTP id k7mr9767479qkg.215.1564437772942;
        Mon, 29 Jul 2019 15:02:52 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id c5sm38542941qta.5.2019.07.29.15.02.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 15:02:52 -0700 (PDT)
Date:   Mon, 29 Jul 2019 15:02:42 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset
 accessors
Message-ID: <20190729150242.09ec9917@cakuba.netronome.com>
In-Reply-To: <94802E4A-536A-4249-BEA3-5D89E8073738@gmail.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
        <20190729171941.250569-2-jonathan.lemon@gmail.com>
        <20190729135043.0d9a9dcb@cakuba.netronome.com>
        <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
        <20190729142211.43b5ccd8@cakuba.netronome.com>
        <20190729142548.028d5a2b@cakuba.netronome.com>
        <94802E4A-536A-4249-BEA3-5D89E8073738@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 14:53:45 -0700, Jonathan Lemon wrote:
> On 29 Jul 2019, at 14:25, Jakub Kicinski wrote:
> 
> > On Mon, 29 Jul 2019 14:22:11 -0700, Jakub Kicinski wrote:  
> >>>> I realize you're following the existing code, but should we perhaps
> >>>> use
> >>>> the latest kdoc syntax? '()' after function name, and args should have
> >>>> '@' prefix, '%' would be for constants.  
> >>>
> >>> That would be a task for a different cleanup.  Not that I disagree with
> >>> you, but there's also nothing worse than mixing styles in the same file.  
> >>
> >> Funny you should say that given that (a) I'm commenting on the new code
> >> you're adding, and (b) you did do an unrelated spelling fix above ;)  
> >
> > Ah, sorry I misread your comment there.
> >
> > Some code already uses '()' in this file, as for the '%' skb_frag_
> > functions are the only one which have this mistake, the rest of kdoc
> > is correct.  
> 
> The kernel-doc.rst guide seems to indicate that function names should
> have () at the end - but none of them do so within this file.  (only when
> talking about the function in the document).

/**
 * skb_complete_tx_timestamp() - deliver cloned skb with tx timestamps

/**
 * skb_tx_timestamp() - Driver hook for transmit timestamping

> The %CONST indicates name of a constant - I'm unclear whether this is
> supposed to refer to a constant parameter.  For example:
> 
> /**
>  *      __skb_peek - peek at the head of a non-empty &sk_buff_head
>  *      @list_: list to peek at
>  *
>  *      Like skb_peek(), but the caller knows that the list is not empty.
>  */
> static inline struct sk_buff *__skb_peek(const struct sk_buff_head *list_)
> {
>         return list_->next;
> }

Hmm.. I'm not sure I follow, this example does not use %, but & which
is for types. Quoting from:

https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#highlights-and-cross-references

@parameter
    Name of a function parameter. (No cross-referencing, just formatting.)
%CONST
    Name of a constant. (No cross-referencing, just formatting.)


So in your case you should use @delta, rather than %delta.
