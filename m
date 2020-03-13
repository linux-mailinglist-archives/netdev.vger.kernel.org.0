Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDB21840DD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgCMGgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:36:47 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:43785 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgCMGgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:36:47 -0400
Received: by mail-ua1-f68.google.com with SMTP id o42so3120012uad.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnA7+an7Vt+IV9m3XQcAcjEL8qkyyR1/kkvvpD9nK5U=;
        b=Wq86ua/gnq6A9YcbGUbxbbWYJoX6l44g/x/c/KZuBnzDHaUeEOixZpmHYqGqxVbcBc
         fxEeKsBuSGrDtbbqF9u0qYSETBpGttxLqslOe6Ds9CoGDlXxWdZ27Bu3CpFhq327JTVN
         JX3jiMjv53G1/Pr+j6hvtmFaWhgRuc4wKn/tnwXh61VMAqrd4aLbcy1EEcQw1vi6N0ag
         0J5kpaDQ+QXfptxJT7SEDdPD+e/l8ekbNh0+hAp9BtiCldUXuQLgAX2ymkIMf0s/e6yD
         vg+7k6ZwA+X+sU8KeLRc7YV1k60aNG+rp+36M3lVRww6MkK9EPrHMpjGIEVdqVpxtE5A
         o77g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnA7+an7Vt+IV9m3XQcAcjEL8qkyyR1/kkvvpD9nK5U=;
        b=sW127Ugj2vJFB7ngcXqsa+66OyzLR2SsDB+xRKr/RD1MAFeO5X7xHZ/Q7H9MgeeKXZ
         4SUi5cYBZduP+Wx0NlRC9+rsOqOlo6gB1poCEm51G7v4tL0soWxKJKC88jy209jXrpc7
         0N9xQIwRyi8u6Dm7sQBNiyp1nSfzRDWTn0JA4bKyYJHiWVsNELL/y4kBee9t9D3ObZV7
         /ZS1shcktrfqHokkz1mskKKgVXIqF7WF9WEqoPIW3v01hCR2AIwtcYvsG6DMSWlDob2n
         QVFhPrEQDxk+Sa7xFseaLyawlTdbvWPjDKGjTtetOrkvte1AkY+kIfMV7ldDRRmyeMai
         XraQ==
X-Gm-Message-State: ANhLgQ0CfKdRzDr1cktiLY5kfF922avSehCQlcSeQiix+RVwPg8zmbq7
        JmiY+mRbf/Glq5A4T6IYyV+WyaQWi5anSQy4YVvRt5xy
X-Google-Smtp-Source: ADFU+vvwmRB1reQ/YkjaNYYj9eFuVIBQNaNUm7CDz1Knxb5zKEdNxaD4joeqLmV6RuKRVz3UtCj85jt8SpcZclRZXas=
X-Received: by 2002:ab0:3ab:: with SMTP id 40mr297167uau.47.1584081406165;
 Thu, 12 Mar 2020 23:36:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200228.120150.302053489768447737.davem@davemloft.net>
 <1583131910-29260-1-git-send-email-kyk.segfault@gmail.com>
 <CABGOaVRdsw=4nqBMR0h8JPEiunOEpHR+02H=HRbgt_TxhVviiA@mail.gmail.com>
 <945f6cafc86b4f1bb18fa40e60d5c113@AcuMS.aculab.com> <CABGOaVQMq-AxwQOJ5DdDY6yLBOXqBg6G7qC_MdOYj_z4y-QQiw@mail.gmail.com>
 <de1012794ec54314b6fe790c01dee60b@AcuMS.aculab.com> <CABGOaVSddVL-T-Sz_GPuRoZbKM_HsZND84rJUm2G9RRw6cUwCQ@mail.gmail.com>
 <CA+FuTSc5QVF_kv8FNs03obXGbf6axrG5umCipE=LXvqQ_-hDAA@mail.gmail.com>
 <817a6418ac8742e6bb872992711beb47@AcuMS.aculab.com> <91fafe40-7856-8b22-c279-55df5d06ca39@gmail.com>
 <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
In-Reply-To: <e8b84bcaee634b53bee797aa041824a4@AcuMS.aculab.com>
From:   Yadu Kishore <kyk.segfault@gmail.com>
Date:   Fri, 13 Mar 2020 12:06:34 +0530
Message-ID: <CABGOaVTzjJengG0e8AWFZE9ZG1245keuQHfRJ0zpoAMQrNmJ6g@mail.gmail.com>
Subject: Re: [PATCH v2] net: Make skb_segment not to compute checksum if
 network controller supports checksumming
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, given the discussion I have no objections. The change to
> skb_segment in v2 look fine.

I'm assuming that the changes in patch V2 are ok to be accepted and merged
to the kernel. Please let me know if there is anything else that is pending
from my side with respect to the patch.

Thanks,
Yadu Kishore

On Fri, Mar 6, 2020 at 10:42 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 05 March 2020 17:20
> >
> > On 3/5/20 9:00 AM, David Laight wrote:
> > > From: Willem de Bruijn
> > >> Sent: 05 March 2020 16:07
> > > ..
> > >> It seems do_csum is called because csum_partial_copy executes the
> > >> two operations independently:
> > >>
> > >> __wsum
> > >> csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
> > >> {
> > >>         memcpy(dst, src, len);
> > >>         return csum_partial(dst, len, sum);
> > >> }
> > >
> > > And do_csum() is superbly horrid.
> > > Not the least because it is 32bit on 64bit systems.
> >
> > There are many versions, which one is discussed here ?
> >
> > At least the current one seems to be 64bit optimized.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5777eaed566a1d63e344d3dd
> > 8f2b5e33be20643e
>
> I was looking at the generic one in $(SRC)/lib/checksum.c.
>
> FWIW I suspect the fastest code on pre sandy bridge 64bit intel cpus
> (where adc is 2 clocks) is to do a normal 'add', shift the carries
> into a 64bit register and do a software 'popcnt' every 512 bytes.
> That may run at 8 bytes/clock + the popcnt.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
