Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982B2CE28F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbgLCXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgLCXUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:20:45 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7816C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 15:20:04 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id l11so2056409plt.1
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GXuimYr6Px3k2gxPin7qGOBHJmkDEgYpMFrcBAI9Oa8=;
        b=FTjotWDLgp/4JbNzLm1M49cCIPHnIw47lbofCzyj63OJFEY5LQ8RdJWLqb1HyrSrSG
         Qrq/TnWGQB8W0EynPYmhguR71FqH/jy5mJl5VeV+w5Sz2xj34fpuWB2puGlF7VrQgz2U
         Rojg3H8emxQrgskoWEPF1shtO/+MJKiStluI+Ee/a56tKvw3vGY62tI7jDegtVWVZy9H
         8NZwpTUim5qiVVuBxft/KiywNWdFgCh5qR2A/qlcqv8vFTYhrcGUC4hHADO3waKAVUnc
         REx/QO26mT4qz+EBdKf/qxLCK32F7jRLsP2Eekw/uHm1+Y3Bt/AGBYDAz6lUK4ImaHTX
         ZiHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GXuimYr6Px3k2gxPin7qGOBHJmkDEgYpMFrcBAI9Oa8=;
        b=lTZIW4CPqJwJEkVIcfxxkYCWRQF5lCrS71bVRBiXk9qN+7hONOinkUdvjdTYmprFuw
         zs9BvAwSPwCqLa6GqS22XrHOsBkW4nNwSWQgQAzBj+guzly1JoEa3GxwA3r0q3xAD9ru
         AA85IKgdYFqQu1jdVBibtfllQFAqRv5X3Br/2AVjAZTuO4nworcaZ/8++2RWvMIgx/fa
         hmrX545weC4abkgnjutiErujEDEtJHqM5W+NgAXGXFjpExHXFE06X7+2ShrlWZgR9neH
         iW34wf7c/mOQsZjPcbMpfd+rToOjzJxrqOWdjL0k3Y42FTP6agMv28mzXvycSVs+EhHG
         /2UA==
X-Gm-Message-State: AOAM531SlOdiI8ukBnKgJE53bLaYZGHjNpU3VBCPpRbHaNGPuA37DLIz
        /UzKldVcQJ3PmIxcOVn9UAbt/WgGEoHGj5ADW9Yw0A==
X-Google-Smtp-Source: ABdhPJzvWYQW4qxncfPtj6eZVtB+UUfgWEsD6Yqr22Ek5kd/Oh75NfyrAyC+2/pDYDCfiWi07ETjKJjsnBjpJb8bSZ4=
X-Received: by 2002:a17:902:ba8b:b029:d9:d8b9:f2d7 with SMTP id
 k11-20020a170902ba8bb02900d9d8b9f2d7mr1375991pls.77.1607037604256; Thu, 03
 Dec 2020 15:20:04 -0800 (PST)
MIME-Version: 1.0
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
 <20201202220945.911116-2-arjunroy.kdev@gmail.com> <20201202161527.51fcdcd7@hermes.local>
 <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
In-Reply-To: <384c6be35cc044eeb1bbcf5dcc6d819f@AcuMS.aculab.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 3 Dec 2020 15:19:53 -0800
Message-ID: <CAOFY-A07C=TEfob3S3-Dqm8tFTavFfEGqQwbisnNd+yKgDEGFA@mail.gmail.com>
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data for
 TCP Rx. zerocopy.
To:     David Laight <David.Laight@aculab.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Arjun Roy <arjunroy.kdev@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "soheil@google.com" <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 3:01 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Stephen Hemminger
> > Sent: 03 December 2020 00:15
> >
> > On Wed,  2 Dec 2020 14:09:38 -0800
> > Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> >
> > > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > > index cfcb10b75483..62db78b9c1a0 100644
> > > --- a/include/uapi/linux/tcp.h
> > > +++ b/include/uapi/linux/tcp.h
> > > @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
> > >     __u32 recv_skip_hint;   /* out: amount of bytes to skip */
> > >     __u32 inq; /* out: amount of bytes in read queue */
> > >     __s32 err; /* out: socket error */
> > > +   __u64 copybuf_address;  /* in: copybuf address (small reads) */
> > > +   __s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>
> You need to swap the order of the above fields to avoid padding
> and differing alignments for 32bit and 64bit apps.
>

Just to double check, are you referring to the order of
copybuf_address and copybuf_len?
If so, it seems that the current ordering is not creating any
alignment holes, but flipping it would: https://godbolt.org/z/bdxP6b


> > >  };
> > >  #endif /* _UAPI_LINUX_TCP_H */
> >
> > You can't safely grow the size of a userspace API without handling the
> > case of older applications.  Logic in setsockopt() would have to handle
> > both old and new sizes of the structure.
>
> You also have to allow for old (working) applications being recompiled
> with the new headers.
> So you cannot rely on the fields being zero even if you are passed
> the size of the structure.
>

I think this should already be taken care of in the current code; the
full-sized struct with new fields is being zero-initialized, then
we're getting the user-provided optlen, then copying from userspace
only that much data. So the newer fields would be zero in that case,
so this should handle the case of new kernels but old applications.
Does this address the concern, or am I misunderstanding?

Thanks,
-Arjun

>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
