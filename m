Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEC60EAED
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 23:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiJZVpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 17:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJZVpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 17:45:01 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2387C2FC3B;
        Wed, 26 Oct 2022 14:45:00 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d26so25108882eje.10;
        Wed, 26 Oct 2022 14:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QyF0Qzmet3oFkaT2R25ZUSwb27jbh43Ykcga5rLid20=;
        b=EDZBZvhhHNP+XexaiKMfO36fwKrZvK0b7e4U95i3fO0vJWfYAwWQTO3ssv7kyeWpAV
         fAJOFn/YqaWWYlO2uD68MGlaxDl7xh6jivReg8IqTUAoCtVAiLJRVKThlwVtVRVudS4H
         haSmoW3zycq6pPflj15C/Ahb6+kTt2Ng5BLgt16sILtBaJMCsLvIkaj4eDWxkdz7U3b/
         BpCfqpBK+dxboFuAQQcv4WcogYMe/xHr7D1UoPRjcfdEGPHXkfyylCr0xyW8SD0Qmgil
         wPjRFvVpKZNlINWvVGc68ptd3yCZ8lzorc7A2IDHYQ+ziR9EkZteli2YiOtZ79PL7Rpr
         vPCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QyF0Qzmet3oFkaT2R25ZUSwb27jbh43Ykcga5rLid20=;
        b=BwzLTvVAJnWkBHSTCfE2DU4vsHhUkx+c+Lp8i8a4Hh7uclk8BzEBzAIfVBEB9R5ZYb
         zLwhELe9NCS47Y3Y3MnZZd1u9UhBuzB6SUEhujO4tCeCbdpP/0UQ+heYB/JZnlvGMBbe
         c7PK/mjPmfn41S42tM6atDc3f/fQMeb+Zsok9qbtkncrInyou4IXt+piFNVXxfMXrj8k
         xFC0lZzCYVxOJZA0Ci3Ib523wi9M9K2fyI417tjmVxSnkvUYDjhVPhbDm9XKrtoSR3Hj
         Ah55f1s1b4LD+9t/GTJ0OKvFoC3Uxo55jrjKYtV4o45VtNHic0KHZTyHtxr2BOzwgV//
         ETgw==
X-Gm-Message-State: ACrzQf2EMaJTAmYHAChby0aKWeM0KoTeLtikBmZXQCawivhe5Y28U+z7
        1DqYpG2GzD1H/1ezsgiu4TA=
X-Google-Smtp-Source: AMsMyM4dgwl0X6W2qOWAZ8qgTjUcf1JH6WO46X3VKI6KuHZfFY31U0YE0ZWKGL/JCYtewKgkGtXVBA==
X-Received: by 2002:a17:906:c14f:b0:793:30e1:96be with SMTP id dp15-20020a170906c14f00b0079330e196bemr34407579ejc.447.1666820698414;
        Wed, 26 Oct 2022 14:44:58 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id sa3-20020a1709076d0300b0074134543f82sm3556174ejc.90.2022.10.26.14.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:44:58 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:44:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Arun.Ramadoss@microchip.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net, b.hutchman@gmail.com
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221026214455.3n5f7eqp3duuie22@skbuf>
References: <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
 <20221026164753.13866-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026164753.13866-1-ceggers@arri.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 26, 2022 at 06:47:53PM +0200, Christian Eggers wrote:
> Hi Arun, hi Vladimir,
> 
> On Tuesday, 18 October 2022, 15:42:41 CEST, Arun.Ramadoss@microchip.com wrote:
> > ...
> > Thanks Vladimir. I will wait for Christian feedback.
> >
> > Hi Christian,
> > To test this patch on KSZ9563, we need to increase the number of
> > interrupts port_nirqs in KSZ9893 from 2 to 3. Since the chip id of
> > KSZ9893 and KSZ9563 are same, I had reused the ksz_chip_data same for
> > both chips. But this chip differ with number of port interrupts. So we
> > need to update it. We are generating a new patch for adding the new
> > element in the ksz_chip_data for KSZ9563.
> > For now, you can update the code as below for testing the patch
> 
> today I hard first success with your patch series on KSZ9563! ptp4l reported
> delay measurements between switch port 1 and the connected Meinberg clock:
> 
> > ptp4l[75.590]: port 2: new foreign master ec4670.fffe.0a9dcc-1
> > ptp4l[79.590]: selected best master clock ec4670.fffe.0a9dcc
> > ptp4l[79.590]: updating UTC offset to 37
> > ptp4l[79.591]: port 2: LISTENING to UNCALIBRATED on RS_SLAVE
> > ptp4l[81.114]: port 2: delay timeout
> > ptp4l[81.117]: delay   filtered        338   raw        338
> > ptp4l[81.118]: port 2: minimum delay request interval 2^1
> > ptp4l[81.434]: port 1: announce timeout
> > ptp4l[81.434]: config item lan0.udp_ttl is 1
> > ptp4l[81.436]: config item (null).dscp_event is 0
> > ptp4l[81.437]: config item (null).dscp_general is 0
> > ptp4l[81.437]: selected best master clock ec4670.fffe.0a9dcc
> > ptp4l[81.438]: updating UTC offset to 37
> > ptp4l[81.843]: master offset         33 s0 freq   +6937 path delay       338
> > ptp4l[82.844]: master offset         26 s2 freq   +6930 path delay       338
> > ptp4l[82.844]: port 2: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
> > ptp4l[83.844]: master offset         32 s2 freq   +6962 path delay       338
> > ptp4l[84.844]: master offset          3 s2 freq   +6943 path delay       338
> > ptp4l[85.844]: master offset        -14 s2 freq   +6927 path delay       338
> > ptp4l[86.042]: port 2: delay timeout
> > ptp4l[86.045]: delay   filtered        336   raw        335
> > ptp4l[86.211]: port 2: delay timeout
> > ptp4l[86.213]: delay   filtered        335   raw        331
> > ptp4l[86.844]: master offset          3 s2 freq   +6939 path delay       335
> > ptp4l[87.847]: master offset         -7 s2 freq   +6930 path delay       335
> 
> As a next step I'll try to configure the external output for 1PPS. Is this
> already implemented in your patches? The file /sys/class/ptp/ptp2/n_periodic_outputs
> shows '0' on my system.

Arun didn't share the PPS output patch publicly, so I don't know why
we're discussing this here. Anyway, in it, Arun (incorrectly)
implemented support for PTP_CLK_REQ_PPS rather than PTP_CLK_REQ_PEROUT,
so there will not be any n_periodic_outputs visible in sysfs. For now,
try via pps_available and pps_enable.

> 
> BTW: Which is the preferred delay measurement which I shall test (E2E/P2P)?

As this time around there is somebody from Microchip finally on the
line, I will not interfere in this part. I tried once, and failed to
understand the KSZ PTP philosophy. I hope you get some answers from
Arun. Just one question below.

> I started with E2E is this was configured in the hardware and needs no 1-step
> time stamping, but I had to add PTP_MSGTYPE_DELAY_REQ in ksz_port_txtstamp().

Hm? So if E2E "doesn't need" 1-step TX timestamping and KSZ9563 doesn't
support 2-step TX timestamping, then what kind of TX timestamping is
used here for Delay_Req messages?

Perhaps you mean that E2E doesn't need moving the RX timestamp of the
Pdelay_Req (t2) into the KSZ TX timestamp trailer of the Pdelay_Resp (t3)?

> > May be this is due to kconfig of config_ksz_ptp  defined bool instead
> > of tristate. Do I need to change the config_ksz_ptp to tristate in
> > order to compile as modules?
> 
> I'm not an expert for kbuild and cannot tell whether it's allowed to use
> bool options which depend on tristate options. At least ksz_ptp.c is compiled
> by kbuild if tristate is used. But I needed to add additional EXPORT_SYMBOL()
> statements for all non-static functions (see below) for successful linking.

If ksz_ptp.o gets linked into ksz_ptp.ko, then yes. But this probably
doesn't make sense, as you point out. So EXPORT_SYMBOL() should not be
needed.

> I'm unsure whether it makes sense to build ksz_ptp as a separate module.
> Perhaps it should be (conditionally) added to ksz_switch.ko.
> 
> On Tuesday, 18 October 2022, 08:44:04 CEST, Arun.Ramadoss@microchip.com wrote:
> > I had developed this patch set to add gPTP support for LAN937x based on
> > the Christian eggers patch for KSZ9563.
> 
> Maybe this could be mentioned somewhere (e.g. extra line in file header of
> ksz_ptp.c).  It took a lot of effort (for me) to get this initially running
> (e.g. due to limited documentation / support by Microchip).  But I'm quite happy
> that this is continued now as it is likely that I'll need PTP support for the
> KSZ9563 soon.
> 
> For KSZ9563, we will need support for 1-step time stamping as two-step
> is not possible.
> 
> I've stashed all my local changes into an additional patch (see below).
> Please feel free to integrate this into your series.  As soon I get 1PPS
> running, I'll continue testing.  Note that I'll be unavailable between Friday
> and next Tuesday.
> 
> regards,
> Christian
>  static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
>  				   struct hwtstamp_config *config)
> @@ -106,7 +108,7 @@ static int ksz_set_hwtstamp_config(struct ksz_device *dev, int port,
>  	case HWTSTAMP_TX_OFF:
>  		prt->hwts_tx_en = false;
>  		break;
> -	case HWTSTAMP_TX_ON:
> +	case HWTSTAMP_TX_ONESTEP_P2P:

One shouldn't replace the other; this implementation is simplistic, of course.

Also, why did you choose HWTSTAMP_TX_ONESTEP_P2P and not HWTSTAMP_TX_ONESTEP_SYNC?

>  		prt->hwts_tx_en = true;
>  		break;
>  	default:
> @@ -162,6 +164,7 @@ int ksz_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
>  	mutex_unlock(&ptp_data->lock);
>  	return ret;
>  }
> +EXPORT_SYMBOL(ksz_hwtstamp_set);
> diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> index 582add3398d3..e7680718b478 100644
> --- a/net/dsa/tag_ksz.c
> +++ b/net/dsa/tag_ksz.c
> @@ -251,17 +251,69 @@ MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477);
>  #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
>  #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
> 
> +/* Time stamp tag is only inserted if PTP is enabled in hardware. */
> +static void ksz9893_xmit_timestamp(struct sk_buff *skb)
> +{
> +//	struct sk_buff *clone = KSZ9477_SKB_CB(skb)->clone;
> +//	struct ptp_header *ptp_hdr;
> +//	unsigned int ptp_type;
> +	u32 tstamp_raw = 0;
> +	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
> +}

This is needed for one-step TX timestamping, ok.

> +
> +/* Defer transmit if waiting for egress time stamp is required.  */
> +static struct sk_buff *ksz9893_defer_xmit(struct dsa_port *dp,
> +					  struct sk_buff *skb)

No need to duplicate, can rename lan937x_defer_xmit() and call that.

Although I'm not exactly clear *which* packets will need deferred
transmission on ksz9xxx. To my knowledge, such a procedure is only
necessary for 2-step TX timestamping, when the TX timestamp must be
propagated back to the socket error queue via skb_complete_tx_timestamp().
For one-step, AFAIK*, this isn't needed.

This is not used, right? Because the function call is shortcircuited by
the "if (test_bit(KSZ_HWTS_EN, &priv->state))" test earlier.

*Or is this intended to be used for the "Software Two-Step Simulation
Mode in hardware 1-Step Mode" that was suggested in the errata sheet,
where one-step Sync messages still get their TX timestamp reported to
user space as if they were two-step?
http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9563R-Errata-80000786B.pdf
