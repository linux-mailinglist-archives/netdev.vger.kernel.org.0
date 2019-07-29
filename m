Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67ED679AFD
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388628AbfG2VWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:22:23 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:34467 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388163AbfG2VWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:22:23 -0400
Received: by mail-vs1-f68.google.com with SMTP id m23so42054423vso.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KLJTNpHdpdiRQ3I+u/2Y8vqqOm/R0pz9Qi6Key0co0Q=;
        b=TQBAfkkxaAKQigJXbbaFTQZHMcKXfDTnD7kYIGS/ZWB+5xwRLGEN5RG1zBGSqZSz5a
         6k2Vfz/tlwAHTXvrp+DM/+mPEn+6C7ZqBNXZ68oxnAzRUZnoAnXAZKhVdgtoOa02yaoZ
         2YxJj5hBg0HQO1vgSEj6dWjI4g1QBLPhNM0c/GcrG+5IwnteckSscfKrmnSGPMJPw5HL
         AC8T5qjFlFAvgjT+gmAgJHJyC0DO6ckn8dSLTsaGe2Fv42vBxTrl0so/WykRApdk+CAj
         jd4UYpYvd2xelCGXqt5jNvkYOL1xc8q6qj6tY2B44VCRud2iJyNf63VZ1Dnvoj7Yzw/y
         6BEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KLJTNpHdpdiRQ3I+u/2Y8vqqOm/R0pz9Qi6Key0co0Q=;
        b=dLvMKwR8KFQ7d0p/efEWIXyJOO39e9TEOZi+64CK5nJsK3M6V6eZ0BfdKnjVq96T8P
         AXJtQ45zAqgqX6t2b3xw4CfJMZJyiA4yLE3FwbysfqXpGXi27I1MhRLNy6MDSy0XVQfh
         kvJczjeMEwxyJuUdqbMkd+Kny5McgdBi+s+l+88eeinFr6FORBKB9H9Uy8MVyRuK34Jv
         CibWFZj7a6qvSf9o84fe0j4jkbnPOrh4DFJGlITrkdzWVtkl9kLLaXOduW1OD855SGqs
         YOMadBgAaRSdYv548sQjxe8R/5CJ1alvlxnhcsuF45Rx+z9ubxeEV7tLeiFQpznj/x5J
         ppQQ==
X-Gm-Message-State: APjAAAV8kRuSuD88qN+2DrfrlCO7pdq51HsdhTP9Uvwxoko8daTdcNdV
        K7YqQTaWHJxLSrTtQw3khPGHmQ==
X-Google-Smtp-Source: APXvYqzfCfm6GYqyWdXy5CNVBQNOKHdAjdFTzuQynqHQ+mYrN46R5I+UKNhmqKYKQSc3u5lxwNJadw==
X-Received: by 2002:a67:f7cd:: with SMTP id a13mr8308745vsp.163.1564435342309;
        Mon, 29 Jul 2019 14:22:22 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j138sm28167274vka.11.2019.07.29.14.22.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 14:22:22 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:22:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Jonathan Lemon" <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset
 accessors
Message-ID: <20190729142211.43b5ccd8@cakuba.netronome.com>
In-Reply-To: <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
        <20190729171941.250569-2-jonathan.lemon@gmail.com>
        <20190729135043.0d9a9dcb@cakuba.netronome.com>
        <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 14:02:21 -0700, Jonathan Lemon wrote:
> On 29 Jul 2019, at 13:50, Jakub Kicinski wrote:
> > On Mon, 29 Jul 2019 10:19:39 -0700, Jonathan Lemon wrote:  
> >> Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
> >> and skb_frag_off_set_from() accessors for page_offset.
> >>
> >> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

> >> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >> index 718742b1c505..7d94a78067ee 100644
> >> --- a/include/linux/skbuff.h
> >> +++ b/include/linux/skbuff.h
> >> @@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t 
> >> *frag, unsigned int size)
> >>  }
> >>
> >>  /**
> >> - * skb_frag_size_add - Incrementes the size of a skb fragment by 
> >> %delta
> >> + * skb_frag_size_add - Increments the size of a skb fragment by 
> >> %delta
> >>   * @frag: skb fragment
> >>   * @delta: value to add
> >>   */
> >> @@ -2857,6 +2857,46 @@ static inline void 
> >> skb_propagate_pfmemalloc(struct page *page,
> >>  		skb->pfmemalloc = true;
> >>  }
> >>
> >> +/**
> >> + * skb_frag_off - Returns the offset of a skb fragment
> >> + * @frag: the paged fragment
> >> + */
> >> +static inline unsigned int skb_frag_off(const skb_frag_t *frag)
> >> +{
> >> +	return frag->page_offset;
> >> +}
> >> +
> >> +/**
> >> + * skb_frag_off_add - Increments the offset of a skb fragment by 
> >> %delta  
> >
> > I realize you're following the existing code, but should we perhaps 
> > use
> > the latest kdoc syntax? '()' after function name, and args should have
> > '@' prefix, '%' would be for constants.  
> 
> That would be a task for a different cleanup.  Not that I disagree with 
> you, but there's also nothing worse than mixing styles in the same file.

Funny you should say that given that (a) I'm commenting on the new code
you're adding, and (b) you did do an unrelated spelling fix above ;)

> >> + * @frag: skb fragment
> >> + * @delta: value to add
> >> + */
> >> +static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
> >> +{
> >> +	frag->page_offset += delta;
> >> +}
> >> +
> >> +/**
> >> + * skb_frag_off_set - Sets the offset of a skb fragment
> >> + * @frag: skb fragment
> >> + * @offset: offset of fragment
> >> + */
> >> +static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int 
> >> offset)
> >> +{
> >> +	frag->page_offset = offset;
> >> +}
> >> +
> >> +/**
> >> + * skb_frag_off_set_from - Sets the offset of a skb fragment from 
> >> another fragment
> >> + * @fragto: skb fragment where offset is set
> >> + * @fragfrom: skb fragment offset is copied from
> >> + */
> >> +static inline void skb_frag_off_set_from(skb_frag_t *fragto,
> >> +					 const skb_frag_t *fragfrom)  
> >
> > skb_frag_off_copy() ?  
> 
> That was my initial inclination, but due to the often overloaded
> connotations of the word "copy", opted to use the same "set" verbiage
> that existed in the other functions.

There is no need to ponder the connotations of verbs. Please just 
look at other function names in skbuff.h, especially those which 
copy fields :)

static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
static inline void skb_copy_secmark(struct sk_buff *to, const struct sk_buff *from)
static inline void skb_copy_queue_mapping(struct sk_buff *to, const struct sk_buff *from)
static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *src)
