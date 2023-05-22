Return-Path: <netdev+bounces-4408-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A7070C5A8
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 21:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62224280FB5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C66A168CD;
	Mon, 22 May 2023 19:04:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1C13AE5
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 19:04:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B911CB0
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684782288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jZ28GuDynsihTAd/3VuLVOzUIH4ZwLQEZqNL+84MuY=;
	b=fq/RIrgTPMs6zmBO5RGLdxi8YbbLpxVCsdK6uL9jIe7PlqxUO5mvpFHVk5vORp9l7eozys
	ti0l8E+cf7We/HVr4vmUF/J7V/MYNCB9n4PCtQz4lVWY0YyK7q1+AM/Qq/e7KhKPOLAech
	1zT2fCzexbg4l+01AowpGAgk5Ne8L20=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-Q2E7O_LpPhKelLlMjTHvJA-1; Mon, 22 May 2023 15:04:46 -0400
X-MC-Unique: Q2E7O_LpPhKelLlMjTHvJA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f5d6dc52fdso20202275e9.0
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:04:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684782285; x=1687374285;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jZ28GuDynsihTAd/3VuLVOzUIH4ZwLQEZqNL+84MuY=;
        b=i8sWlzjDYXeAYpo0oBzEyJkoiB/28NJg1nJsHlLQfmmz/5XYHnc7fV0C6dpbN+z0eH
         NwvBAv1Xf55duQ0N5WTZJDeTW9jqvx9x86hqA+CnQv6uMGrlyxqnkI7dw23dPaRBpIUR
         VB3gavlD/xISMqDoohzKvfrhR7JsI1JAzoVgWtPUq+4MFtSxqCm0m1AbcBTMXTIWSjd/
         TMHcNbNhIqHAfdGjSMOIMt6GC7p98iCC5CuAxBKf7cxG6QDc3qDmgvxNUsbpiicBp85I
         FCJ9gso0J0n0nf4D+fHDP9I2pU62C5u5yjsBd4N2Z/a6K7N9hisVmFuhO4H4iwbSzO+J
         SonQ==
X-Gm-Message-State: AC+VfDxAGkBIJycNiPz9Gvm+gBF+pd1yS3uTEyTz3hfIVs4amb1VWh2l
	T/uuplf/5ZJJ09kMcuGq8qXXq8/ukKR16lQ6VE+NUKLyI1OE6pTXCIZW9cbXs6Gn3a8hx4PnUrS
	Tewr1VS0NyjSolLuZ
X-Received: by 2002:a1c:790b:0:b0:3f6:1ac:5feb with SMTP id l11-20020a1c790b000000b003f601ac5febmr4329584wme.16.1684782285369;
        Mon, 22 May 2023 12:04:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7QbSewB6BsJ5gKLZmpBeVzToPF+5tO7N7Pm53qG70bIifqfT4ySC3qTsizV5jxSdSGcFqtiQ==
X-Received: by 2002:a1c:790b:0:b0:3f6:1ac:5feb with SMTP id l11-20020a1c790b000000b003f601ac5febmr4329567wme.16.1684782284967;
        Mon, 22 May 2023 12:04:44 -0700 (PDT)
Received: from redhat.com ([2.52.20.68])
        by smtp.gmail.com with ESMTPSA id z10-20020a05600c220a00b003f50e29bce3sm9169360wml.48.2023.05.22.12.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 12:04:44 -0700 (PDT)
Date: Mon, 22 May 2023 15:04:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Willem de Bruijn <willemb@google.com>
Cc: Shannon Nelson <shannon.nelson@amd.com>,
	"Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	intel-wired-lan@lists.osuosl.org, simon.horman@corigine.com,
	leon@kernel.org, decot@google.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org,
	"Singhai, Anjali" <anjali.singhai@intel.com>,
	"Orr, Michael" <michael.orr@intel.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Message-ID: <20230522144241-mutt-send-email-mst@kernel.org>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <7969d09e-2b77-c1a7-0e38-f10d61c83638@amd.com>
 <CA+FuTSfUvSDFZ95d8urmEcRLMU6pnb_t-7OwV-dcJPU=mAEnkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSfUvSDFZ95d8urmEcRLMU6pnb_t-7OwV-dcJPU=mAEnkg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 01:12:43PM -0400, Willem de Bruijn wrote:
> On Fri, May 19, 2023 at 12:17 PM Shannon Nelson <shannon.nelson@amd.com> wrote:
> >
> > On 5/18/23 4:26 PM, Samudrala, Sridhar wrote:
> > > On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
> > >> On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
> > >>>
> > >>>
> > >>> On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> > >>>> On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
> > >>>>> This patch series introduces the Intel Infrastructure Data Path
> > >>>>> Function
> > >>>>> (IDPF) driver. It is used for both physical and virtual functions.
> > >>>>> Except
> > >>>>> for some of the device operations the rest of the functionality is the
> > >>>>> same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> > >>>>> structures defined in the virtchnl2 header file which helps the driver
> > >>>>> to learn the capabilities and register offsets from the device
> > >>>>> Control Plane (CP) instead of assuming the default values.
> > >>>>
> > >>>> So, is this for merge in the next cycle?  Should this be an RFC rather?
> > >>>> It seems unlikely that the IDPF specification will be finalized by that
> > >>>> time - how are you going to handle any specification changes?
> > >>>
> > >>> Yes. we would like this driver to be merged in the next cycle(6.5).
> > >>> Based on the community feedback on v1 version of the driver, we
> > >>> removed all
> > >>> references to OASIS standard and at this time this is an intel vendor
> > >>> driver.
> > >>>
> > >>> Links to v1 and v2 discussion threads
> > >>> https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
> > >>> https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
> > >>>
> > >>> The v1->v2 change log reflects this update.
> > >>> v1 --> v2: link [1]
> > >>>   * removed the OASIS reference in the commit message to make it clear
> > >>>     that this is an Intel vendor specific driver
> > >>
> > >> Yes this makes sense.
> > >>
> > >>
> > >>> Any IDPF specification updates would be handled as part of the
> > >>> changes that
> > >>> would be required to make this a common standards driver.
> > >>
> > >>
> > >> So my question is, would it make sense to update Kconfig and module name
> > >> to be "ipu" or if you prefer "intel-idpf" to make it clear this is
> > >> currently an Intel vendor specific driver?  And then when you make it a
> > >> common standards driver rename it to idpf?  The point being to help make
> > >> sure users are not confused about whether they got a driver with
> > >> or without IDPF updates. It's not critical I guess but seems like a good
> > >> idea. WDYT?
> > >
> > > It would be more disruptive to change the name of the driver. We can
> > > update the pci device table, module description and possibly driver
> > > version when we are ready to make this a standard driver.
> > > So we would prefer not changing the driver name.
> >
> > More disruptive for who?
> >
> > I think it would be better to change the name of the one driver now
> > before a problem is created in the tree than to leave a point of
> > confusion for the rest of the drivers to contend with in the future.
> 
> This discussion is premised on the idea that the drivers will
> inevitably fork, with an Intel driver and a non-backward compatible
> standardized driver.
> 
> Instead, I expect that the goal is that the future standardized driver
> will iterate and support additional features. But that the existing
> hardware will continue to be supported, if perhaps with updated
> firmware.
> 
> IDPF from the start uses feature negotiation over virtchannel to be
> highly configurable. A future driver might deprecate older feature
> (variants), while either still continue to support those or require
> firmware updates to match the new version.
> 
> Even if the device API would break in a non-backward compatible way,
> the same driver can support both versions. Virtio is an example of
> this.
> 
> If I'm wrong and for some reason two drivers would have to be
> supported, then I'm sure we can figure out a suffix or prefix to the
> standard driver that separates it from the existing one.


OK let us look at a more specific example.

The IDPF TC recently voted to bind to device
based on class/programming interface as opposed to device/vendor id.
Future driver will likely do this. Current driver only binds to intel's
device and vendor id. Assuming this happens, what bothers me is that
depending on kernel version, driver idpf.ko either does or does not bind
to idpf programming interface.

All this is quite imminent.

Yes tricks like checking module version to check what is supported is
possible, but we are beginning to already develop technical dept and
lore and we just started. Simple lsmod|grep -q idpf seems like an
easier, more robust and intuitive way than if [[ $(cat
/sys/module/idpf/version) == "2.0" ]] then echo "idpf" fi

And yes somemore might ship the existing driver
during this initial window. Then we get
lsmod|grep -q -e idpf -e intel-ipu
still seems pretty clean. And hopefully the change will happen within
a couple of months so not more than one release will have
the intel-ipu name.

Of course all this is not earth shatteringly important but still,
I'm interested in what others think.

-- 
MST


