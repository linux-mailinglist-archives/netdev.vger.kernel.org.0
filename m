Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E2C4B9D1D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 11:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiBQK2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 05:28:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiBQK2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 05:28:04 -0500
Received: from asav22.altibox.net (asav22.altibox.net [109.247.116.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3518E8BF08;
        Thu, 17 Feb 2022 02:27:47 -0800 (PST)
Received: from canardo.mork.no (207.51-175-193.customer.lyse.net [51.175.193.207])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmork@altiboxmail.no)
        by asav22.altibox.net (Postfix) with ESMTPSA id 38C9F2114A;
        Thu, 17 Feb 2022 11:27:45 +0100 (CET)
Received: from miraculix.mork.no ([IPv6:2a01:799:95f:8b0a:1e21:3a05:ad2e:f4a6])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 21HARi2s2786275
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 17 Feb 2022 11:27:44 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1645093664; bh=mNRoAjxp+1Mcl3J+9TltWEo3Lu9eV9NW0A5v/Yx0mB8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=kWaEJOvqWmXkOK90XcnI1OZXRi2IkFtBXV59ycgQH8tbNNbvAwokjpPwz2leWEsqc
         v65WRFvIOJWHomNGqfkMGqVIIMr7OlAO/gmHyWNMeIi1pwO/6WAe97/LeRR+DN56Qo
         teeJg5Q+2Yct74AT98hTD+InGxt9e6hIs85pOZ10=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1nKe0h-003G9h-2g; Thu, 17 Feb 2022 11:27:39 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stern@rowland.harvard.edu, USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuliano Belinassi <giuliano.belinassi@suse.com>
Subject: Re: malicious devices causing unaligned accesses [v2]
Organization: m
References: <281493dd-4b3c-3c99-8491-f5e6b0af602f@suse.com>
Date:   Thu, 17 Feb 2022 11:27:39 +0100
In-Reply-To: <281493dd-4b3c-3c99-8491-f5e6b0af602f@suse.com> (Oliver Neukum's
        message of "Thu, 17 Feb 2022 09:46:09 +0100")
Message-ID: <87sfshaiuc.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.103.3 at canardo
X-Virus-Status: Clean
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=KbX8TzQD c=1 sm=1 tr=0
        a=XJwvrae2Z7BQDql8RrqA4w==:117 a=XJwvrae2Z7BQDql8RrqA4w==:17
        a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=oGFeUVbbRNcA:10 a=M51BFTxLslgA:10
        a=iox4zFpeAAAA:8 a=JZIobH7kNtm7zT1GFWEA:9 a=QEXdDO2ut3YA:10
        a=WzC6qhA0u3u7Ye7llzcV:22
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com> writes:

> Hi,
>
> going through the USB network drivers looking for ways
> a malicious device could do us harm I found drivers taking
> the alignment coming from the device for granted.
>
> An example can be seen in qmi_wwan:
>
> while (offset + qmimux_hdr_sz < skb->len) {
> =C2=A0=C2=A0=C2=A0 hdr =3D (struct qmimux_hdr*)(skb->data + offset);
> =C2=A0=C2=A0=C2=A0 len =3D be16_to_cpu(hdr->pkt_len);
>
> As you can see the driver accesses stuff coming from the device with the
> expectation
> that it keep to natural alignment. On some architectures that is a way a
> device could use to do bad things to a host. What is to be done about
> that?

We can deal with this the same way we deal with hostile hot-plugged CPUs
or memory modules.

Yes, the aligment should probably be verified.  But there are so many
ways a hostile network adapter can mess with us than I don't buy the
"malicious device" argument...

FWIW, the more recent rmnet demuxing implementation from Qualcomm seems
to suffer from the same problem.


struct sk_buff *rmnet_map_deaggregate(struct sk_buff *skb,
				      struct rmnet_port *port)
{
	struct rmnet_map_header *maph;
	struct sk_buff *skbn;
	u32 packet_len;

	if (skb->len =3D=3D 0)
		return NULL;

	maph =3D (struct rmnet_map_header *)skb->data;
	packet_len =3D ntohs(maph->pkt_len) + sizeof(struct rmnet_map_header);


(this implementation moves skb->data by packet_len instead of doing the
offset calculation, but I don't think that makes any difference?)

I guess there is no alignment guarantee here, whether the device is
malicious or not. So we probably have to deal with unaligned accesses to
maph/hdr->pkt_len?



Bj=C3=B8rn
