Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3DAE65E9E5
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 12:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbjAEL2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 06:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbjAEL2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 06:28:13 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86C2395D5
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 03:28:11 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4a2f8ad29d5so172823507b3.8
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 03:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YW0JmDgfbaKWv4q9TiEyTj0eCQFFREQC3a91rJG1Kwc=;
        b=ooLD+ubOG6z6J4wyjnsLBLgF3YYcls6L8UKEgAVzc2pFxSD093eLNwRxjxNHiIEpOD
         QxBRsBpWVJxp955i8W4eSNFlXnOJgpYGwDDWvwWp9BY38P8lI2pT7H05YewwvCeuTgld
         VqA2l7VMUy1U61FxldWu6wNbTWYwPo4sfYbm/mwOJ0tADta3tbRF1oMr7eViMohjvupE
         yGFTpH1bXwWcnDb6oaY/6jikaCBw0lKkmpQddvUlUsKMpMcbqEsmmsOxap//u81rC7OJ
         Y9tWQ3VrGh0UYWG/WsuLJyIAlYSz5/IqYqqE8dZ3Q4SXNw17J9C0T7wsnMkN78bq5pX3
         VzRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YW0JmDgfbaKWv4q9TiEyTj0eCQFFREQC3a91rJG1Kwc=;
        b=YlvpRdaWT4iFv8H1rrUTscynDCaLOaCE2Wx2y4BO9e8AMm3/yDK2aLVFshqqxFgZh5
         UQPF/FUYalGEPIe50BhQJv4uvJmELXgBoe5uD0iWPjb6YES3J0ORWxBiXzG3+SusL2AR
         fhVpgDBP+qoQJJLmSLPN+r9LdGAQIIZRfLbsmFXounc0kxyPkAXT7fhBS3J58qyL/FTE
         tABUYdHKuBvYZ/eBWfdXhr1ODCWluo78oiUyA8FJzQWWy/pFvpifiD8iSD4EjABTnnwa
         0uGEdFDgHfDOtazSADQl+IREcTLKXNBCkfXEv+EGx7dlTBHTWTP4pYCiwtbpQzJyIMp+
         myYQ==
X-Gm-Message-State: AFqh2kq7Y20cqCDPguaFyEwEe4d65to5E/zemSsizFm3yrBTtecD6CvK
        rPzCBwWMI+N4lDpZhKpSbb5a9n5sJlV21KdwuJYXv8AtbZp3WHlA
X-Google-Smtp-Source: AMrXdXu/SUNwck2pv14UPcQwtHCrCsIQcVzQAFKAkJohCuxUJiUlydk8M6HGX4drW/uenXHK3G1qLcuav4Mpm62S2Bk=
X-Received: by 2002:a81:1a08:0:b0:46b:c07c:c1d5 with SMTP id
 a8-20020a811a08000000b0046bc07cc1d5mr4661928ywa.55.1672918090632; Thu, 05 Jan
 2023 03:28:10 -0800 (PST)
MIME-Version: 1.0
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
 <20230104084316.4281-7-arun.ramadoss@microchip.com> <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
In-Reply-To: <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 5 Jan 2023 12:27:59 +0100
Message-ID: <CANn89i+XJzpXycUE_iiyRYQ-f-EkkBCD5FtdvbYfBy8pvOZ5qw@mail.gmail.com>
Subject: Re: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P clocks
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        richardcochran@gmail.com, ceggers@arri.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 11:09 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hi,
>
> On Wed, 2023-01-04 at 14:13 +0530, Arun Ramadoss wrote:
> > From: Christian Eggers <ceggers@arri.de>
> >
> > For P2P delay measurement, the ingress time stamp of the PDelay_Req is
> > required for the correction field of the PDelay_Resp. The application
> > echoes back the correction field of the PDelay_Req when sending the
> > PDelay_Resp.
> >
> > Some hardware (like the ZHAW InES PTP time stamping IP core) subtracts
> > the ingress timestamp autonomously from the correction field, so that
> > the hardware only needs to add the egress timestamp on tx. Other
> > hardware (like the Microchip KSZ9563) reports the ingress time stamp via
> > an interrupt and requires that the software provides this time stamp via
> > tail-tag on tx.
> >
> > In order to avoid introducing a further application interface for this,
> > the driver can simply emulate the behavior of the InES device and
> > subtract the ingress time stamp in software from the correction field.
> >
> > On egress, the correction field can either be kept as it is (and the
> > time stamp field in the tail-tag is set to zero) or move the value from
> > the correction field back to the tail-tag.
> >
> > Changing the correction field requires updating the UDP checksum (if UDP
> > is used as transport).
> >
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> > Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> > ---
> > v1 -> v2
> > - Fixed compilation issue when PTP_CLASSIFY not selected in menuconfig
> > as reported by kernel test robot <lkp@intel.com>
> > ---
> >  include/linux/ptp_classify.h | 71 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 71 insertions(+)
> >
> > diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> > index 2b6ea36ad162..6e5869c2504c 100644
> > --- a/include/linux/ptp_classify.h
> > +++ b/include/linux/ptp_classify.h
> > @@ -10,8 +10,12 @@
> >  #ifndef _PTP_CLASSIFY_H_
> >  #define _PTP_CLASSIFY_H_
> >
> > +#include <asm/unaligned.h>
> >  #include <linux/ip.h>
> > +#include <linux/ktime.h>
> >  #include <linux/skbuff.h>
> > +#include <linux/udp.h>
> > +#include <net/checksum.h>
> >
> >  #define PTP_CLASS_NONE  0x00 /* not a PTP event message */
> >  #define PTP_CLASS_V1    0x01 /* protocol version 1 */
> > @@ -129,6 +133,67 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
> >       return msgtype;
> >  }
> >
> > +/**
> > + * ptp_check_diff8 - Computes new checksum (when altering a 64-bit field)
> > + * @old: old field value
> > + * @new: new field value
> > + * @oldsum: previous checksum
> > + *
> > + * This function can be used to calculate a new checksum when only a single
> > + * field is changed. Similar as ip_vs_check_diff*() in ip_vs.h.
> > + *
> > + * Return: Updated checksum
> > + */
> > +static inline __wsum ptp_check_diff8(__be64 old, __be64 new, __wsum oldsum)
> > +{
> > +     __be64 diff[2] = { ~old, new };
> > +
> > +     return csum_partial(diff, sizeof(diff), oldsum);
> > +}
> > +
> > +/**
> > + * ptp_header_update_correction - Update PTP header's correction field
> > + * @skb: packet buffer
> > + * @type: type of the packet (see ptp_classify_raw())
> > + * @hdr: ptp header
> > + * @correction: new correction value
> > + *
> > + * This updates the correction field of a PTP header and updates the UDP
> > + * checksum (if UDP is used as transport). It is needed for hardware capable of
> > + * one-step P2P that does not already modify the correction field of Pdelay_Req
> > + * event messages on ingress.
> > + */
> > +static inline
> > +void ptp_header_update_correction(struct sk_buff *skb, unsigned int type,
> > +                               struct ptp_header *hdr, s64 correction)
> > +{
> > +     __be64 correction_old;
> > +     struct udphdr *uhdr;
> > +
> > +     /* previous correction value is required for checksum update. */
> > +     memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
> > +
> > +     /* write new correction value */
> > +     put_unaligned_be64((u64)correction, &hdr->correction);
> > +
> > +     switch (type & PTP_CLASS_PMASK) {
> > +     case PTP_CLASS_IPV4:
> > +     case PTP_CLASS_IPV6:
> > +             /* locate udp header */
> > +             uhdr = (struct udphdr *)((char *)hdr - sizeof(struct udphdr));
> > +             break;
> > +     default:
> > +             return;
> > +     }
> > +
> > +     /* update checksum */
> > +     uhdr->check = csum_fold(ptp_check_diff8(correction_old,
> > +                                             hdr->correction,
> > +                                             ~csum_unfold(uhdr->check)));
> > +     if (!uhdr->check)
> > +             uhdr->check = CSUM_MANGLED_0;
>
> AFAICS the above works under the assumption that skb->ip_summed !=
> CHECKSUM_COMPLETE, and such assumption is true for the existing DSA
> devices.

Presumably skb->ip_summed could be forced to CHECKSUM_NONE

Note: if IPV4 UDP checksum is zero, we are not supposed to change it.

(Not sure if this point is already checked in caller)

>
> Still the new helper is a generic one, so perhaps it should take care
> of CHECKSUM_COMPLETE, too? Or at least add a big fat warning in the
> helper documentation and/or a warn_on_once(CHECKSUM_COMPLETE).
>
> Thanks!
>
> Paolo
>
