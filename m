Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D01029553F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 01:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507174AbgJUXjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 19:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439511AbgJUXjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 19:39:39 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF00BC0613CE;
        Wed, 21 Oct 2020 16:39:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u8so5721222ejg.1;
        Wed, 21 Oct 2020 16:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U/NFBZUA11BiPKqlGyVQZkBGpt7qn+BV8S9808FnS7A=;
        b=mBlfXCGLx4R/WWUKda0kQ+kvYLB4uUl7Vc+mB7sknGZEGVslFPt39Sy9Y21NgCjnti
         SX0y8hKJet/zRSp7EId0ngZybsCz7H6tdw8sRi63WrXxH18aGrAQ0zaYCx5K7FRjppQy
         hmvq8JYl1wlT91NY7EIuuZFXPItKmY3gCAWi+7K54q71UpOdsTTiuk0ojQxDz/AlrkG0
         Pl5guVokIIyznBTjyaKKXIh1Q0V2jXt1ndVm2o82XU2QZ00R66IwjZyZOaFlvZlffC+y
         9j+a+bQcoYk+xpdaHLKoQSQncXhzzRpaIDIc2js4c0mhGktY/shJTWmij8upfhKSwCkx
         iqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U/NFBZUA11BiPKqlGyVQZkBGpt7qn+BV8S9808FnS7A=;
        b=SKAqM7p3jhKaTjZRs+M/yQWhpNPXHMd5iK8SxaPwFmgVre4iSCETcrtn+9/Hadm3pV
         gsAFfA4j52lxKU02QKR+lgFb+TcSPFLQGZ+9CuGiHSYDDVF6NKQycw1P47TVnjPVMPJr
         eoqJIqicguzwkOCaP1M64QbD/JQnOe6XJSSFTjqf6xMCNX/c9PE4RA4iX39Sh6l7g+zK
         qo1fx+Ftwr9vXwtnA1cRRuufq8XGUFD5IkX145KXWTbnsFiuinPL9Jur+gN4/BMYF9qf
         mxMNCtVEG2nnwFui2GwVS1yo++EHdsHanZuotwava5rbfcya8R7cdEkVqqvcRBfVImH3
         kvJQ==
X-Gm-Message-State: AOAM532adrUXWeoEaRi5C5MWSQamnvl/0bqduDfn19THOThK5Zy8femK
        IPJzE31X1I0gIbu6MjkrLCs=
X-Google-Smtp-Source: ABdhPJykEbE7lN7AHJ/kIMZ+UNqRaxBLojy0NPUaLvbLXIKrZUDjzTa4fNekW2JbNygdfeUpgD4j8w==
X-Received: by 2002:a17:906:54d8:: with SMTP id c24mr5587428ejp.499.1603323577571;
        Wed, 21 Oct 2020 16:39:37 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id h22sm2925667ejc.80.2020.10.21.16.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 16:39:36 -0700 (PDT)
Date:   Thu, 22 Oct 2020 02:39:35 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201021233935.ocj5dnbdz7t7hleu@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019172435.4416-8-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 07:24:33PM +0200, Christian Eggers wrote:
> Add routines required for TX hardware time stamping.
> 
> The KSZ9563 only supports one step time stamping
> (HWTSTAMP_TX_ONESTEP_P2P), which requires linuxptp-2.0 or later. PTP
> mode is permanently enabled (changes tail tag; depends on
> CONFIG_NET_DSA_MICROCHIP_KSZ9477_PTP).TX time stamps are reported via an
> interrupt / device registers whilst RX time stamps are reported via an
> additional tail tag.
> 
> One step TX time stamping of PDelay_Resp requires the RX time stamp from
> the associated PDelay_Req message. linuxptp assumes that the RX time
> stamp has already been subtracted from the PDelay_Req correction field
> (as done by the TI PHYTER). linuxptp will echo back the value of the
> correction field in the PDelay_Resp message.
> 
> In order to be compatible to this already established interface, the
> KSZ9563 code emulates this behavior. When processing the PDelay_Resp
> message, the time stamp is moved back from the correction field to the
> tail tag, as the hardware doesn't support negative values on this field.
> Of course, the UDP checksums (if any) have to be corrected after this
> (for both directions).
> 
> The PTP hardware performs internal detection of PTP frames (likely
> similar as ptp_classify_raw() and ptp_parse_header()). As these filters
> cannot be disabled, the current delay mode (E2E/P2P) and the clock mode
> (master/slave) must be configured via sysfs attributes. Time stamping
> will only be performed on PTP packets matching the current mode
> settings.
> 
> Everything has been tested on a Microchip KSZ9563 switch.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Hi Richard!

Looks like we've been discussing without you here. I had an off-list discussion
with Christian and we just realized that. The topic of this email is that we've
got new P2P one-step hardware coming in, and it's not quite API-compatible with
what's there already (you might not actually be surprised by that).

Since you weren't copied to Christian's patches, here's a patchwork link for you:
https://patchwork.ozlabs.org/project/netdev/cover/20201019172435.4416-1-ceggers@arri.de/

Short introduction by quoting from the IEEE 1588 standard, just to get everybody
on the same page.

----------------------------------[cut here]-----------------------------------

11.4.3 Peer delay mechanism operational specifications
------------------------------------------------------

The actual value of the meanPathDelay shall be measured and computed as follows
for each instance of a peer delay request-response measurement:

(a) The delay requestor, Node-A:
    (1) Prepares a Pdelay_Req message. The correctionField (see 13.3.2.7) shall
        be set to 0.
    (2) If asymmetry corrections are required, shall modify the correctionField
        per 11.6.4.
    (3) Shall set the originTimestamp to 0 or an estimate no worse than +/-1s of
        the egress timestamp, t1, of the Pdelay_Req message.
    (4) Shall send the Pdelay_Req message and generate and save timestamp t1.
(b) If the delay responder, Node-B, is a one-step clock, it shall:
    (1) Generate timestamp t2 upon receipt of the Pdelay_Req message
    (2) Prepare a Pdelay_Resp message
    (3) Copy the sequenceId field from the Pdelay_Req message to the sequenceId
        field of the Pdelay_Resp message
    (4) Copy the sourcePortIdentity field from the Pdelay_Req message to the
        requestingPortIdentity field of the Pdelay_Resp message
    (5) Copy the domainNumber field from the Pdelay_Req message to the
        domainNumber field of the Pdelay_Resp message
    (6) Copy the correctionField from the Pdelay_Req message to the
        correctionField of the Pdelay_Resp message
    (7) Then:
        (i) Set to 0 the requestReceiptTimestamp field of the Pdelay_Resp message
        (ii) Issue the Pdelay_Resp message and generate timestamp t3 upon sending
        (iii) After t3 is generated but while the Pdelay_Resp message is
              leaving the responder, shall add the turnaround time t3 - t2 to
              the correctionField of the Pdelay_Resp message and make any
              needed corrections to checksums or other content-dependent fields
              of the Pdelay_Resp message
(c) If the delay responder is a two-step clock, it shall:
    [skipping because in our case, the delay responder is a one-step clock]
(d) The delay requestor, Node-A, shall:
    (1) Generate timestamp t 4 upon receipt of the Pdelay_Resp message
    (2) If asymmetry corrections are required, modify the correctionField of
        the Pdelay_Resp message per 11.6.5
    (3) If the twoStepFlag of the received Pdelay_Resp message is FALSE,
        indicating that no Pdelay_Resp_Follow_Up message will be received,
        compute the <meanPathDelay> as:
        <meanPathDelay> = [(t4 - t1) - correctionField of Pdelay_Resp] / 2

----------------------------------[cut here]-----------------------------------

Simply put:

          |                    |
       t1 |------\ Pdelay_Req  |
          |       ------\      |
          |              ----->| t2
Clock A   |                    |     Clock B
          | Pdelay_Resp /------| t3
          |       ------       |
       t4 |<-----/             |
          |                    |

                (t4 - t1) - (t3 - t2)
meanPathDelay = ---------------------
                          2

where t3 - t2 (the "turnaround" time) is contained inside the correctionField
of the Pdelay_Resp. To reiterate, t3 is the RX timestamp of the Pdelay_Req, and
t4 is the TX timestamp of the Pdelay_Resp, both taken at the delay responder
(Clock B).

That was about it for the standard.


The hardware that Christian is configuring (consider operation as Clock B)
works this way:
(a) the ingress port takes the t2 RX timestamp of the Pdelay_Req normally
(b) on transmission of the Pdelay_Resp, the kernel must provide t2 as metadata
    together with the Pdelay_Resp frame itself (it is put in the "TX timestamp"
    field of the DSA tag)
(c) the egress port takes the t3 TX timestamp and rewrites the correctionField
    of the PTP header with the (t3 - t2) value

Straightforward, one might say?
Except for the fact that this is not how the API for peer-to-peer one-step
timestamping currently works.
We were expecting that for this switch to have a streamlined implementation for
P2P 1-step, the kernel would have an API to inject a Pdelay_Resp packet into
the stack _along_ with t2. But it doesn't.

So how _does_ that work for TI PHYTER?

As far as we understand, the PHYTER appears to autonomously mangle PTP packets
in the following way:
- subtracting t2 on RX from the correctionField of the Pdelay_Req
- adding t3 on TX to the correctionField of the Pdelay_Resp

All that linuxptp has to do is connect the wires. That's why in process_pdelay_req()
from port.c, there is:

	if (p->timestamping == TS_P2P1STEP) {
		rsp->header.correction = m->header.correction;

Otherwise said, the t2 is not provided to the kernel explicitly, but simply by
copying the correctionField from the Pdelay_Req into the Pdelay_Resp. This
correctionField is the play ground of the PHYTER, so by having linuxptp copy
that field, it simply has a path to finish off what it started. We believe that
by the time the Pdelay_Req message arrives at the host, the correctionField
will be negative, and it will only become back positive after transmitting the
Pdelay_Resp. This is also something that might be problematic for other devices.

Nevertheless, I'm not here to say that it's wrong to do what we are currently
doing for PHYTER. I mean, paragraph 11.4.3.(b).(6) clearly states that the
correctionField should be transferred anyway from the Pdelay_Req to the
Pdelay_Resp. I am not entirely sure of the reasons why it stipulates this, if
it's just to allow hardware like PHYTER to operate within spec, or if it's for
the delay requestor to be aware of the correction that was applied to his frame.
Regardless of which way it is, we expect that any 1588 stack will have to do
that, so this is not implementation-defined behavior.

What I'm here to say is that this is not how Christian's hardware works, and he
is simply emulating the kernel interface used by the PHYTER. He needs to
subtract t2 on RX from the correctionField manually in the tagger code, then
have extra code on TX to copy t2 from the correctionField into the DSA tag's TX
timestamp field. This complicates the code by quite a significant margin, and
my concern is that nobody is going to follow what's going on while
maintaining it, and why it is done in this backwards way.
We would like to know your opinion on whether we couldn't, in fact, have a more
straightforward UAPI for hardware like his. For example, expand the sendmsg()
API with a new cmsg that contains t2 specifically for P2P one-step
timestamping. Or anything else. But "straightforward" should be the key.

Thanks,
-Vladimir
