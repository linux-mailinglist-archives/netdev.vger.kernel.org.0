Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F714482AA8
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiABJWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 04:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiABJWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 04:22:11 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E373C061574
        for <netdev@vger.kernel.org>; Sun,  2 Jan 2022 01:22:11 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d9so64293816wrb.0
        for <netdev@vger.kernel.org>; Sun, 02 Jan 2022 01:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=65c+vp54Z6Mn/mDI/c39wMcCk14qgfi9vmJ0haVurHM=;
        b=PQDMq7dGkQ0zkgK8oSDBWLD75Rruvp/gw652ZOhp/raC2e5F2NcMFNicvt43pE9yYd
         lpkWWoTVLBCmKus6xAn6u5u6xiwBlJSnHHA+ZXvejTw3enxNJHUA6U1zzqCbUKNCyHaj
         3xWaOkHEpjBrc3Rzq30JRiKT4U6mgftsqqVo2DJFC9D5VRuDsJFDy3l1Gr8uTamW9wYC
         oeHlG6ivy1WJC+6gnctMnVlld3Pqq307LTF8C1fYT8RuIMvV6HD7ulwX3c2tUchFH1oK
         7iS7mtLLKK0UQBKFj6Uvphpcvz8/6MlpGzL6id8mISOiNWB24t3s+50jOhp/dU2zldOD
         Um9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=65c+vp54Z6Mn/mDI/c39wMcCk14qgfi9vmJ0haVurHM=;
        b=KJq80NWlv4tH/aLDUpufFu8woOlFSvIx5ldfBcNVZAi1a0MMqMIBj7pdkVG4FgbNON
         u28scjIJasZSV9kHRaqyZ/4BlEx/B4Rv81gyA1oi+eaaJyBVLSlwah8ERcn4d5RH3YOr
         H81ouzWHAgDg7joVphs4/SeVu+WRj5sw6bKuOGd2XYQtAIjsVvFnMZQsvPR+6OYpwFml
         4xbPy+tLjxzp2G0/kwt6db+UQPGcWt945uHF7y33lbrqdiNj4BtivV7gGA+aCyNCLf5J
         307rxalGJNyyb786QavpSPoTsvGcNNwVxJW35f9Vb6LlgWoGJkTHQWsYQ7Ct0dhSvOrJ
         Hplg==
X-Gm-Message-State: AOAM533DOAcL6wy5l4+L/bO96Z16AxQHtxVYqAfSIjyWFCm5h4Vn0VJB
        avT2BGGicxnkHmmFf0iXFXc=
X-Google-Smtp-Source: ABdhPJyQDXPEW3Zxv/xVb05rrsEJzuJPvs3z9LBoafG0lYK46V3PgyCbumoJ5ZRC6wWE51kTpFbsmw==
X-Received: by 2002:a5d:4d42:: with SMTP id a2mr35278689wru.311.1641115329765;
        Sun, 02 Jan 2022 01:22:09 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id u9sm33372454wmm.7.2022.01.02.01.22.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 02 Jan 2022 01:22:09 -0800 (PST)
Date:   Sun, 2 Jan 2022 09:22:07 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
Subject: Re: Bad performance in RX with sfc 40G
Message-ID: <20220102092207.rxz7kpjii4ermnfo@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        Dinan Gunawardena <dinang@xilinx.com>
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
 <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
 <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Íñigo,

On Thu, Dec 23, 2021 at 02:18:03PM +0100, Íñigo Huguet wrote:
> Hi Martin,
> 
> I replied this a few weeks ago, but it seems that, for some reason, I
> didn't CCd you.

I'm just getting back to work after my holidays. Happy new year!

> On Thu, Dec 9, 2021 at 1:06 PM Íñigo Huguet <ihuguet@redhat.com> wrote:
> >
> > Hi,
> >
> > On Sat, Nov 20, 2021 at 9:31 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> > > If you're testing without the IOMMU enabled I suspect the recycle ring
> > > size may be too small. Can your try the patch below?
> >
> > Sorry for the very late reply, but I've had to be out of work for many days.
> >
> > This patch has improved the performance a lot, reaching the same
> > 30Gbps than in TX. However, it seems sometimes a bit erratic, still
> > dropping to 15Gbps sometimes, specially after module remove & probe,
> > or from one iperf call to another. But not being all the times, I
> > didn't found a clear pattern. Anyway, it clearly improves things.

Thanks for the feedback. After module probe the RX cache is cold (empty),
as pages only get recycled as they come in.
The issue you see between iperf calls could be related to the NUMA
locality of the cache. After the 1st run the cache will contain pages for
the NUMA node that iperf ran on. If a subsequent run executes on a
different NUMA node the pages in the cache are further away.
This is where pinning the iperf runs to cores on the same NUMA node will
help.

> > Can this patch be applied as is or it's just a test?

The patch is good for a 40G NIC. But it won't be good enough on a 100G NIC,
and for a 10G NIC the size can be smaller.
I've been puzzling over the way to code this link speed dependency best.
We create this page ring when the interface is brought up, which is
before the driver knows the link speed. So I think it is best to
size it for the maximum speed of a given NIC.
In short, I'll work on a better patch for this.

Martin
