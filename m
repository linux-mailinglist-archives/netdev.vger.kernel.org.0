Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968A825254C
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHZBvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgHZBvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:51:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FDAC061574;
        Tue, 25 Aug 2020 18:51:48 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r15so144621wrp.13;
        Tue, 25 Aug 2020 18:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6lKBXswTrzhA0xBsr6HB8AlB5+bACM8/QHtln5EsmDM=;
        b=rkPU8zA6FnvPI7YRdwlrF32Z+jufZRPGDhsVbublBxI+2WdfyrQZ4OMYugj2LjMgRs
         tcBC2iVxYnWeg8Zk6YWzQfE0csZvqLsQKSxRKrpJnxvpSdJ9HVsaxBuVVCZ33a7Fy89F
         YzL00nv71TEx1KwJewv+LaAx654GeLawZ3dB08BJtkewTW0RxdimmA59/2c32/oJxdK5
         dSKP0GfmMvAUQJfWlO1JkSN5McliJO+sig5zbM32H0/Kuj9D+O0+2QWE9ikcOBAgMoCE
         knF+3yVSHzD+dH7rwDtBk3Dij3c2i2NaVRbX/WHThEgypBISYgNE6EdHQjalStrd+n7R
         ERAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6lKBXswTrzhA0xBsr6HB8AlB5+bACM8/QHtln5EsmDM=;
        b=Smmunnpt1LjXpGp/N/t0FV0JpDIO+k456WlcUpDewg1p2nTBOA1P67S7CZhYS2eSnR
         +OOu2WflF/myrmiKXjLyTDaOm9yWRQ/+m8rWhp4lfGRIQPptsKuzcIbQK/gfqzrsmgb2
         BdQeToImOPECJssEo1/TBCGYzI7wfdeorUnpu7sSaErjF0BZxrIBwxej/FG4QVGmlh2X
         1BHiv36vlSmis5BKaAtrqFc4MD1qxap9ZHiDz2gBaMW3K4hIGCY8DekMKBubBcRoWA2R
         RBoRwxM4sCife/uTbJfjeAzX/lJkNnPNGkYKMD/Hi0cHsiYPB61eiVR70QtO+4h+3P/C
         fPwA==
X-Gm-Message-State: AOAM530oFG3ifVTPrO+3udsr1xhmkYJh0IEhN4H2KNWhmkrJD+j5JUa9
        fGPsJZQ/BpxSlrw+43if6fdezIzMsx/vRGp6QYY=
X-Google-Smtp-Source: ABdhPJyeqlKj5YPc50Em7rO4ODLMTr2DC/m+jfMJDMOpF+XoOI2kKLAaJQ+LNrc4dhPoiuNEDU0+R/Ls8lv1xf0wUss=
X-Received: by 2002:adf:db43:: with SMTP id f3mr14164955wrj.219.1598406706678;
 Tue, 25 Aug 2020 18:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-2-allen.cryptic@gmail.com> <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
 <202008171228.29E6B3BB@keescook> <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
 <202008171246.80287CDCA@keescook> <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
 <1597780833.3978.3.camel@HansenPartnership.com> <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
 <1597849185.3875.7.camel@HansenPartnership.com> <CAOMdWSJRR0BhjJK1FxD7UKxNd5sk4ycmEX6TYtJjRNR6UFAj6Q@mail.gmail.com>
 <1597873172.4030.2.camel@HansenPartnership.com>
In-Reply-To: <1597873172.4030.2.camel@HansenPartnership.com>
From:   Allen Pais <allen.cryptic@gmail.com>
Date:   Wed, 26 Aug 2020 07:21:35 +0530
Message-ID: <CAEogwTCH8qqjAnSpT0GDn+NuAps8dNbfcPVQ9h8kfOWNbzrD0w@mail.gmail.com>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Allen <allen.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie,
        Daniel Vetter <daniel@ffwll.ch>, sre@kernel.org,
        kys@microsoft.com, deller@gmx.de, dmitry.torokhov@gmail.com,
        jassisinghbrar@gmail.com, shawnguo@kernel.org,
        s.hauer@pengutronix.de, maximlevitsky@gmail.com, oakad@yahoo.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 3:09 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Wed, 2020-08-19 at 21:54 +0530, Allen wrote:
> > > [...]
> > > > > Since both threads seem to have petered out, let me suggest in
> > > > > kernel.h:
> > > > >
> > > > > #define cast_out(ptr, container, member) \
> > > > >     container_of(ptr, typeof(*container), member)
> > > > >
> > > > > It does what you want, the argument order is the same as
> > > > > container_of with the only difference being you name the
> > > > > containing structure instead of having to specify its type.
> > > >
> > > > Not to incessantly bike shed on the naming, but I don't like
> > > > cast_out, it's not very descriptive. And it has connotations of
> > > > getting rid of something, which isn't really true.
> > >
> > > Um, I thought it was exactly descriptive: you're casting to the
> > > outer container.  I thought about following the C++ dynamic casting
> > > style, so out_cast(), but that seemed a bit pejorative.  What about
> > > outer_cast()?
> > >
> > > > FWIW, I like the from_ part of the original naming, as it has
> > > > some clues as to what is being done here. Why not just
> > > > from_container()? That should immediately tell people what it
> > > > does without having to look up the implementation, even before
> > > > this becomes a part of the accepted coding norm.
> > >
> > > I'm not opposed to container_from() but it seems a little less
> > > descriptive than outer_cast() but I don't really care.  I always
> > > have to look up container_of() when I'm using it so this would just
> > > be another macro of that type ...
> > >
> >
> >  So far we have a few which have been suggested as replacement
> > for from_tasklet()
> >
> > - out_cast() or outer_cast()
> > - from_member().
> > - container_from() or from_container()
> >
> > from_container() sounds fine, would trimming it a bit work? like
> > from_cont().
>
> I'm fine with container_from().  It's the same form as container_of()
> and I think we need urgent agreement to not stall everything else so
> the most innocuous name is likely to get the widest acceptance.

Kees,

  Will you be  sending the newly proposed API to Linus? I have V2
which uses container_from()
ready to be sent out.

Thanks.
