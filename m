Return-Path: <netdev+bounces-3820-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFEA7708F96
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 07:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB3491C21208
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 05:50:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C94A659;
	Fri, 19 May 2023 05:50:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844277C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 05:50:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C01D2
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 22:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684475412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R2hzrnI5esYTTOUV9jOS70d88iTnE+AXFNmudpYyxXI=;
	b=SOh+e7KvW9iT0ZHXC0ofQlimmFMGpEeNxNgKkFh9iHS7twP1beXZf8lypz3WZLfvubSD8b
	pWamibJSR4rDL8pyVzCGT8T80RlK7Uv4H5SrsUvmX7u62txidObkoYoPdNS3DiXoN64TJD
	45IlYR4n49dMPFu5OzwLjDkkHCE8GI4=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-RF0qAMqwPcew5ct-ftQT0w-1; Fri, 19 May 2023 01:50:11 -0400
X-MC-Unique: RF0qAMqwPcew5ct-ftQT0w-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2acfaf0c1ffso15557381fa.3
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 22:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684475409; x=1687067409;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2hzrnI5esYTTOUV9jOS70d88iTnE+AXFNmudpYyxXI=;
        b=WFuUHaerK43DZFwZ2rPnQjxjR9a/vC4XnaD7kep/QCPkDkqEfiNyo/yDeSONX6XIS4
         YE5OdyeTnbcr/9D3wvTE1x+7cTMXaTMLLQEbDZx7HCS9UlBXwJq3AowwHpb5fdl8XK/K
         elcLwVDtAtjuLtla/B3liLgKspEc9fR43Clro+sNtE7iPXGWu+xOBDEsRRYoUHhNMZZf
         IfcJ7IJqyQgnKL0cbOo2Pjmord036+oaMT0POfTjKFbxl5dCg9YuDarDzuCsBFC4c3Oz
         1orcmdmuCRvmNWSXaeEr9ISw51ouRXiHST3YCbzyYnD+8Hn0k1+RK1H8o0cjktCs6DAu
         LxPA==
X-Gm-Message-State: AC+VfDxUwuFr/pKw0ScbBr96vy1K7zOqZrGX71l7okqLpM5zFBy2hlwL
	znGXv5wsTEzUQXC6+iNHRHRAgOzuznjYgO9aNzKo9CNoI5/vq+PAQ1ok2hccaqsptz2env3Da/O
	RKo16dYEdiL1XQfnH
X-Received: by 2002:ac2:5581:0:b0:4f3:aaf0:f672 with SMTP id v1-20020ac25581000000b004f3aaf0f672mr494256lfg.45.1684475409783;
        Thu, 18 May 2023 22:50:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7niOFPsZwqOneqGIAkM65yM1Ou6ocpJ0Gx3ZF3fF1AMiWM8NU4v0NkXeSdXsR/sV1uYPYNhA==
X-Received: by 2002:ac2:5581:0:b0:4f3:aaf0:f672 with SMTP id v1-20020ac25581000000b004f3aaf0f672mr494237lfg.45.1684475409450;
        Thu, 18 May 2023 22:50:09 -0700 (PDT)
Received: from redhat.com ([2a02:14f:175:3e4d:6703:27b9:6f74:5282])
        by smtp.gmail.com with ESMTPSA id z17-20020ac24191000000b004eb2f35045bsm470970lfh.269.2023.05.18.22.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 22:50:08 -0700 (PDT)
Date: Fri, 19 May 2023 01:49:56 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc: Emil Tantilov <emil.s.tantilov@intel.com>,
	intel-wired-lan@lists.osuosl.org, shannon.nelson@amd.com,
	simon.horman@corigine.com, leon@kernel.org, decot@google.com,
	willemb@google.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org,
	"Singhai, Anjali" <anjali.singhai@intel.com>,
	"Orr, Michael" <michael.orr@intel.com>
Subject: Re: [PATCH iwl-next v4 00/15] Introduce Intel IDPF driver
Message-ID: <20230519013710-mutt-send-email-mst@kernel.org>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 04:26:24PM -0700, Samudrala, Sridhar wrote:
> 
> 
> On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
> > On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
> > > 
> > > 
> > > On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> > > > On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
> > > > > This patch series introduces the Intel Infrastructure Data Path Function
> > > > > (IDPF) driver. It is used for both physical and virtual functions. Except
> > > > > for some of the device operations the rest of the functionality is the
> > > > > same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> > > > > structures defined in the virtchnl2 header file which helps the driver
> > > > > to learn the capabilities and register offsets from the device
> > > > > Control Plane (CP) instead of assuming the default values.
> > > > 
> > > > So, is this for merge in the next cycle?  Should this be an RFC rather?
> > > > It seems unlikely that the IDPF specification will be finalized by that
> > > > time - how are you going to handle any specification changes?
> > > 
> > > Yes. we would like this driver to be merged in the next cycle(6.5).
> > > Based on the community feedback on v1 version of the driver, we removed all
> > > references to OASIS standard and at this time this is an intel vendor
> > > driver.
> > > 
> > > Links to v1 and v2 discussion threads
> > > https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
> > > https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
> > > 
> > > The v1->v2 change log reflects this update.
> > > v1 --> v2: link [1]
> > >   * removed the OASIS reference in the commit message to make it clear
> > >     that this is an Intel vendor specific driver
> > 
> > Yes this makes sense.
> > 
> > 
> > > Any IDPF specification updates would be handled as part of the changes that
> > > would be required to make this a common standards driver.
> > 
> > 
> > So my question is, would it make sense to update Kconfig and module name
> > to be "ipu" or if you prefer "intel-idpf" to make it clear this is
> > currently an Intel vendor specific driver?  And then when you make it a
> > common standards driver rename it to idpf?  The point being to help make
> > sure users are not confused about whether they got a driver with
> > or without IDPF updates. It's not critical I guess but seems like a good
> > idea. WDYT?
> 
> It would be more disruptive to change the name of the driver. We can update
> the pci device table, module description and possibly driver version when we
> are ready to make this a standard driver.
> So we would prefer not changing the driver name.

Kconfig entry and description too?

-- 
MST


