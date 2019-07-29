Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A6479B92
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbfG2Vxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:53:48 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44762 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388967AbfG2Vxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:53:48 -0400
Received: by mail-pf1-f196.google.com with SMTP id t16so28658622pfe.11
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ScN80fVH3cspM7ncwEEpiVCYZFKEKQtGint6I/El+MI=;
        b=KKZJWr05RutDUniRHPbsLSqiG0LuizZl+Vwj3eqLVFAoGSA8MwDyG2FbKb1IIiTmnn
         zyzAzSAxNVxSl1wVBi6WtelsJ++H3JQUteh6DLwGISf8T8XGAMmNat+VE85Ia+LuIFAU
         +F3yRJQADwUqI9nSSi0i6vqWHFtuAwM4inq5rwvtm2X7ESGy7Ws8PR4/pBOp2UXWQgT6
         RKPBO+I8pTj46amvQLwtwgcdPP8Lm/IbmgUE3BU3zhFLxEcOxPJp0lkCAPZOnO2GEVw3
         /aRipcMcAq/rG1DIjPtiY4AXBGnpp5+zMPcHdzgdBHnTw3dfmi+j/AgRcQAl8Wgq1/Ko
         5gJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ScN80fVH3cspM7ncwEEpiVCYZFKEKQtGint6I/El+MI=;
        b=nHb2eHsl57tOJYg5fh+4yqu2Ycs4Iys0yHpWY0T2umHjy3ya/MPSuxYuzhC4pPW8zy
         KQYkHX4zi412ZmOlcDGla6ZA/4kgJwy/g874ObpA3uQVOw6BxkPvn9SHsF7RoSmTpIPo
         +KAGJTYjwYmkwEpaUXjVWv9okapCDF1E34eWvnpEpcXeRUmQk6GjJ06uQoco49srMP+f
         5ExiEDB/Fzqi9RJjqPwlA+7/FqI7/Y6/qrayOVVsDiSsWU5yEZmKe5u0WlHxBOkHqzpD
         hqyTFSxjMz1soNTh4G8l94aOfMGeFGzX9G93JUx2tIFHDqcflhMw4ShS5aXFt+6WXylp
         zXTA==
X-Gm-Message-State: APjAAAXzKeic6fex681VymL70XpiSatLzLo8TsCR8PMWGSC4UsWeJtpC
        /JjIZ5U7leRZvx2EyqTD0f9h7sDs
X-Google-Smtp-Source: APXvYqzB+4I0owzXvblM8p7QE3yp5QdUOqX9TPs+x4BTkWz05eQh8AukSFt/bcO2kPyUTdlfm+8ywA==
X-Received: by 2002:a17:90a:9a95:: with SMTP id e21mr13524144pjp.98.1564437227648;
        Mon, 29 Jul 2019 14:53:47 -0700 (PDT)
Received: from [172.20.52.209] ([2620:10d:c090:200::2:3dee])
        by smtp.gmail.com with ESMTPSA id h16sm67406033pfo.34.2019.07.29.14.53.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:53:46 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset accessors
Date:   Mon, 29 Jul 2019 14:53:45 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <94802E4A-536A-4249-BEA3-5D89E8073738@gmail.com>
In-Reply-To: <20190729142548.028d5a2b@cakuba.netronome.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
 <20190729171941.250569-2-jonathan.lemon@gmail.com>
 <20190729135043.0d9a9dcb@cakuba.netronome.com>
 <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
 <20190729142211.43b5ccd8@cakuba.netronome.com>
 <20190729142548.028d5a2b@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29 Jul 2019, at 14:25, Jakub Kicinski wrote:

> On Mon, 29 Jul 2019 14:22:11 -0700, Jakub Kicinski wrote:
>>>> I realize you're following the existing code, but should we perhaps
>>>> use
>>>> the latest kdoc syntax? '()' after function name, and args should have
>>>> '@' prefix, '%' would be for constants.
>>>
>>> That would be a task for a different cleanup.  Not that I disagree with
>>> you, but there's also nothing worse than mixing styles in the same file.
>>
>> Funny you should say that given that (a) I'm commenting on the new code
>> you're adding, and (b) you did do an unrelated spelling fix above ;)
>
> Ah, sorry I misread your comment there.
>
> Some code already uses '()' in this file, as for the '%' skb_frag_
> functions are the only one which have this mistake, the rest of kdoc
> is correct.

The kernel-doc.rst guide seems to indicate that function names should
have () at the end - but none of them do so within this file.  (only when
talking about the function in the document).

The %CONST indicates name of a constant - I'm unclear whether this is
supposed to refer to a constant parameter.  For example:

/**
 *      __skb_peek - peek at the head of a non-empty &sk_buff_head
 *      @list_: list to peek at
 *
 *      Like skb_peek(), but the caller knows that the list is not empty.
 */
static inline struct sk_buff *__skb_peek(const struct sk_buff_head *list_)
{
        return list_->next;
}
