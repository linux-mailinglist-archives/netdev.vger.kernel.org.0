Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1921D65E950
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjAEKu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbjAEKuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:50:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E4544C2
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672915758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJ9c84ROsMvUG/uEafEzSGIJRM2/BeEphDcwehifZUo=;
        b=OR3FGuCBZfZ94EaaUEeUvczPWVnrVdBiudx8HfOWE9C3rKYbAU3/BKDdqI2oMz0FL1W3e0
        PibmOXPJjjPIegzJepWPPrwNM2JPKxlzvQIA2XZzzZ2fiOrQnE4tBITtUlPYc4pMT/MSXE
        WLaxXWcREkFMIM0PWBvcBB4+cXKh2so=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-228-ij06LWujPhK3Yo55Ns7viw-1; Thu, 05 Jan 2023 05:49:17 -0500
X-MC-Unique: ij06LWujPhK3Yo55Ns7viw-1
Received: by mail-wr1-f72.google.com with SMTP id o14-20020adfa10e000000b002631c56fe26so4704578wro.1
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 02:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JJ9c84ROsMvUG/uEafEzSGIJRM2/BeEphDcwehifZUo=;
        b=0npEPsQJ6Y2+JwG+eFpR8KCOPdkw3WSR3QoOuUHl0Cz2nPO3uIdaX6/iD8jsXR1IEs
         Hjc/qmsHt9MP1pBXZZ2aZx2zJNhNMognuzxWD4fh1AeCs0qrlb6+hy2GirVcftQP9ZcI
         vp9wNhmBQSh7lBXQcucy++vH+vX6YxPIkeew1FhVATDdQ3yrb9lqBRgcQp1xVlrIA378
         jvhkoJJq5vj8YqYz1exTK9ELGFcf4EH18iS6I+89PhDgq90x81GE9hhUrq3MbF1CHM5A
         sffJQBjkI5LhbMZCvu8QEZ4bLHGQBiHbMc7m4AJnnd8KxmTyiumoPB/4SBk3TicZ05RS
         me6w==
X-Gm-Message-State: AFqh2kpWH5iV+k/W/n0FPC06KZKBgoMleX0EVb878FK1jI9j+ifHKB5s
        0JCnfn3DS13GVhqSq7m7luWHXYbAYf2P9qwpWr0ysda1esuaeaN/PmelBDgxNxV0Bx+xjbpX+hI
        PrVWLoPQvXLXNyM3x
X-Received: by 2002:a05:600c:3545:b0:3d9:a145:9ab with SMTP id i5-20020a05600c354500b003d9a14509abmr16804880wmq.39.1672915756324;
        Thu, 05 Jan 2023 02:49:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXunU9aoZgc9bUddO6+pFojimtklUp5BcUknBHILu2mZQDKsC6kWWx+HI3qKdtPkRufBDWdriQ==
X-Received: by 2002:a05:600c:3545:b0:3d9:a145:9ab with SMTP id i5-20020a05600c354500b003d9a14509abmr16804853wmq.39.1672915756022;
        Thu, 05 Jan 2023 02:49:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-31.dyn.eolo.it. [146.241.105.31])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003b4ff30e566sm6510517wms.3.2023.01.05.02.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:49:15 -0800 (PST)
Message-ID: <bab8cb9e4916ed9f55c720883183812f4e1f717f.camel@redhat.com>
Subject: Re: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        richardcochran@gmail.com, ceggers@arri.de
Date:   Thu, 05 Jan 2023 11:49:13 +0100
In-Reply-To: <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
         <20230104084316.4281-7-arun.ramadoss@microchip.com>
         <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-05 at 11:09 +0100, Paolo Abeni wrote:
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
> >  	return msgtype;
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
> > +	__be64 diff[2] = { ~old, new };
> > +
> > +	return csum_partial(diff, sizeof(diff), oldsum);
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
> > +				  struct ptp_header *hdr, s64 correction)
> > +{
> > +	__be64 correction_old;
> > +	struct udphdr *uhdr;
> > +
> > +	/* previous correction value is required for checksum update. */
> > +	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
> > +
> > +	/* write new correction value */
> > +	put_unaligned_be64((u64)correction, &hdr->correction);
> > +
> > +	switch (type & PTP_CLASS_PMASK) {
> > +	case PTP_CLASS_IPV4:
> > +	case PTP_CLASS_IPV6:
> > +		/* locate udp header */
> > +		uhdr = (struct udphdr *)((char *)hdr - sizeof(struct udphdr));
> > +		break;
> > +	default:
> > +		return;
> > +	}
> > +
> > +	/* update checksum */
> > +	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
> > +						hdr->correction,
> > +						~csum_unfold(uhdr->check)));
> > +	if (!uhdr->check)
> > +		uhdr->check = CSUM_MANGLED_0;
> 
> AFAICS the above works under the assumption that skb->ip_summed !=
> CHECKSUM_COMPLETE, and such assumption is true for the existing DSA
> devices.
> 
> Still the new helper is a generic one, so perhaps it should take care
> of CHECKSUM_COMPLETE, too? Or at least add a big fat warning in the
> helper documentation and/or a warn_on_once(CHECKSUM_COMPLETE).

I see this helper is used later even in the tx path, so even packet
with ip_summed == CHECKSUM_PARTIAL could reach here and should be
accomodated accordingly.

Thanks,

Paolo


