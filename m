Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E19C79B45
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388827AbfG2Vhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:37:52 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33995 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388781AbfG2Vhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:37:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so22675172pgc.1
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 14:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=OtvKK4Q2qWgFNvrl+IOC1fs1J/NUHPJuJ3GIW8jm5Jo=;
        b=MG9j2QBifsSq9P1jI400qHSvCbmLCsXV5R+AtiLuvylkpThaJmvvDcOB1WLg3G8ylW
         Tj3NF534RtJtnq0kTKMZDExR33dZYfiqloNNR+3qtq65viUJ6i/HiGrXPryP8FnjVtMF
         eThgLPftC3elgbJxyvnbOyI3GB8Nki1uGC0e5cP0b/Ai/S46JFe30RYvCvvfbh9d8jil
         6m9BH2hO8I4CJ6bfr0ywNb1TVcYWUnpACyI0A8y/hrXJRqF4V44teKmSTxJJ/IFFFVX4
         ktbG6RS+liHmXh86tHcN2lY5GXGdPVZT7f99bcew+wvRl0fvCDRmBkhLYCOMFtoNe+2Y
         yoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=OtvKK4Q2qWgFNvrl+IOC1fs1J/NUHPJuJ3GIW8jm5Jo=;
        b=L6Amxs/R0l1tJFyHaGosnJmLawFzwjCHZnoq/FupmnjfT+PmaI6YKyXuYeSHe3Ty2U
         17F6Fy/sspjNVG3f8AkSIcSAQVRJO19w/aZ0zWL8Azbs9w0+jfzmsD47sJvJvdoc4nWJ
         3VDflHUvfAoVx7l7DTKeTZPBJtn4Wf7VwAUq/LcSXFg6nZ4PQsAJpGqMpzh0YeH2uyWH
         2aFV7hCv3FnoHonTE35onsDcq/rn70qzixTqv27AlgNGZS5/7LdNEkswdlnBaIaHRnn0
         zwbX1yFXVER6ougDLI0CUP9xA4iE0KSzYrMyLIhp54gYRDNrzOBr34sNuW/4I7Gvf7hg
         +0QQ==
X-Gm-Message-State: APjAAAUv18kOo6XYzQGolrPJJJVRJguF3TteXqKzeuCqlYEyVMvPxJQW
        uQQCrebw3x18/OVidjnn07c=
X-Google-Smtp-Source: APXvYqxp5qS4nJy2NntCBR0eIuOA/cUMvNE/dq2UvNLE3sr50CRDRbb62DfRCsz5ozxlHcVdfBkNeQ==
X-Received: by 2002:a63:1018:: with SMTP id f24mr19918531pgl.343.1564436270819;
        Mon, 29 Jul 2019 14:37:50 -0700 (PDT)
Received: from [172.20.52.209] ([2620:10d:c090:200::2:3dee])
        by smtp.gmail.com with ESMTPSA id s67sm64152364pjb.8.2019.07.29.14.37.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 14:37:50 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jakub Kicinski" <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, kernel-team@fb.com, netdev@vger.kernel.org,
        "Matthew Wilcox" <willy@infradead.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset accessors
Date:   Mon, 29 Jul 2019 14:37:49 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <552A5F1D-1A1A-4B4B-A88C-7D303A2D0B82@gmail.com>
In-Reply-To: <20190729142211.43b5ccd8@cakuba.netronome.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
 <20190729171941.250569-2-jonathan.lemon@gmail.com>
 <20190729135043.0d9a9dcb@cakuba.netronome.com>
 <932D725D-62F1-47D6-807A-45F81E66B1C6@gmail.com>
 <20190729142211.43b5ccd8@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29 Jul 2019, at 14:22, Jakub Kicinski wrote:

> On Mon, 29 Jul 2019 14:02:21 -0700, Jonathan Lemon wrote:
>> On 29 Jul 2019, at 13:50, Jakub Kicinski wrote:
>>> On Mon, 29 Jul 2019 10:19:39 -0700, Jonathan Lemon wrote:
>>>> Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
>>>> and skb_frag_off_set_from() accessors for page_offset.
>>>>
>>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>
>>>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>>>> index 718742b1c505..7d94a78067ee 100644
>>>> --- a/include/linux/skbuff.h
>>>> +++ b/include/linux/skbuff.h
>>>> @@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t
>>>> *frag, unsigned int size)
>>>>  }
>>>>
>>>>  /**
>>>> - * skb_frag_size_add - Incrementes the size of a skb fragment by
>>>> %delta
>>>> + * skb_frag_size_add - Increments the size of a skb fragment by
>>>> %delta
>>>>   * @frag: skb fragment
>>>>   * @delta: value to add
>>>>   */
>>>> @@ -2857,6 +2857,46 @@ static inline void
>>>> skb_propagate_pfmemalloc(struct page *page,
>>>>  		skb->pfmemalloc = true;
>>>>  }
>>>>
>>>> +/**
>>>> + * skb_frag_off - Returns the offset of a skb fragment
>>>> + * @frag: the paged fragment
>>>> + */
>>>> +static inline unsigned int skb_frag_off(const skb_frag_t *frag)
>>>> +{
>>>> +	return frag->page_offset;
>>>> +}
>>>> +
>>>> +/**
>>>> + * skb_frag_off_add - Increments the offset of a skb fragment by
>>>> %delta
>>>
>>> I realize you're following the existing code, but should we perhaps
>>> use
>>> the latest kdoc syntax? '()' after function name, and args should 
>>> have
>>> '@' prefix, '%' would be for constants.
>>
>> That would be a task for a different cleanup.  Not that I disagree 
>> with
>> you, but there's also nothing worse than mixing styles in the same 
>> file.
>
> Funny you should say that given that (a) I'm commenting on the new 
> code
> you're adding, and (b) you did do an unrelated spelling fix above ;)
>
>>>> + * @frag: skb fragment
>>>> + * @delta: value to add
>>>> + */
>>>> +static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
>>>> +{
>>>> +	frag->page_offset += delta;
>>>> +}
>>>> +
>>>> +/**
>>>> + * skb_frag_off_set - Sets the offset of a skb fragment
>>>> + * @frag: skb fragment
>>>> + * @offset: offset of fragment
>>>> + */
>>>> +static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int
>>>> offset)
>>>> +{
>>>> +	frag->page_offset = offset;
>>>> +}
>>>> +
>>>> +/**
>>>> + * skb_frag_off_set_from - Sets the offset of a skb fragment from
>>>> another fragment
>>>> + * @fragto: skb fragment where offset is set
>>>> + * @fragfrom: skb fragment offset is copied from
>>>> + */
>>>> +static inline void skb_frag_off_set_from(skb_frag_t *fragto,
>>>> +					 const skb_frag_t *fragfrom)
>>>
>>> skb_frag_off_copy() ?
>>
>> That was my initial inclination, but due to the often overloaded
>> connotations of the word "copy", opted to use the same "set" verbiage
>> that existed in the other functions.
>
> There is no need to ponder the connotations of verbs. Please just
> look at other function names in skbuff.h, especially those which
> copy fields :)
>
> static inline void skb_copy_hash(struct sk_buff *to, const struct 
> sk_buff *from)
> static inline void skb_copy_secmark(struct sk_buff *to, const struct 
> sk_buff *from)
> static inline void skb_copy_queue_mapping(struct sk_buff *to, const 
> struct sk_buff *from)
> static inline void skb_ext_copy(struct sk_buff *dst, const struct 
> sk_buff *src)

Okay, I missed those, let me respin.
-- 
Jonathan
