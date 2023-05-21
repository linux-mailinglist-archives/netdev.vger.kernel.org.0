Return-Path: <netdev+bounces-4097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A315F70AD32
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 11:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 370AB280FC3
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 09:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E4D10EF;
	Sun, 21 May 2023 09:21:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682C10E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 09:21:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9C393
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 02:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684660890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x3g3aQcnmbrJVCV2d6q556xVnveXmKbQ1XA+jcIMHIs=;
	b=ZDgmBfmf0ER/wabfpmTluLg/t5e7PTE2hK+C/p5PR/eGNHveSftqFY3XW6SaUA/EsbuPZY
	YDOb84DCxBY6RJGRETK6z5XEE5zM7kGijnKMod9PhIfJYjNjt6e90WUSG+mPvkPpw9cb5o
	eRf+/MUjNF2BKUe6CHHmF01i09KSYcY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-Uo9H_Q_VP2G53uGWJ6CFPg-1; Sun, 21 May 2023 05:21:28 -0400
X-MC-Unique: Uo9H_Q_VP2G53uGWJ6CFPg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3097ebd267dso462896f8f.0
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 02:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684660887; x=1687252887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x3g3aQcnmbrJVCV2d6q556xVnveXmKbQ1XA+jcIMHIs=;
        b=f7CA4QnYBkcq6JW9tyPLw1wp+O5VbNz2tja2gFCkAOJlKaMepyyCUqDg4rup/cavVH
         QadTtL++uclp0X/1cbm6QTSyNvYMJGTPKFfIY1bpiN3llHOcv9qwvL7U0KVE9NWoGEZI
         vUvB1pUTyBdyp8oG9oS/pYzNmchyWPdtskJsxqZWHjmuzvic77DYwCIdrK1Np5qdj6/r
         EL5mpwcJgYF8Xysg5TRkrVddjoC+13pJjr6RNw6RLCJoceeSElEnmPKlfD+C4/XejH/w
         CuUT9Hxpda6QpE0pwmzT6c81+fNBVRMcea80F9ZXwX1eCR8eyIjEbAngEkTi47ORqx0D
         Dr6w==
X-Gm-Message-State: AC+VfDwk/6wfCEYIHras0e2EBpaiC4SfCo/kxTj37og3H8Pf+e+flHaJ
	S2nP+mJ+KW9DFRQvAFn1oIyrxodYJihVxmH5c59Lr9V2sgpWwuml6KX126R2HSveIwtrHXAWtlz
	v8TA5cNKmZw04BAgo
X-Received: by 2002:adf:f48a:0:b0:309:48eb:cdf9 with SMTP id l10-20020adff48a000000b0030948ebcdf9mr4783554wro.38.1684660887617;
        Sun, 21 May 2023 02:21:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Am96kBS0gZnQmAV189AcZbdMbzVv+JePcNcmnlmKbPxD7/O3O/4Fgu09ri+ms+CY+ZmC7pw==
X-Received: by 2002:adf:f48a:0:b0:309:48eb:cdf9 with SMTP id l10-20020adff48a000000b0030948ebcdf9mr4783529wro.38.1684660887294;
        Sun, 21 May 2023 02:21:27 -0700 (PDT)
Received: from redhat.com ([2.52.11.67])
        by smtp.gmail.com with ESMTPSA id e5-20020a5d4e85000000b003047dc162f7sm4143486wru.67.2023.05.21.02.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 02:21:26 -0700 (PDT)
Date: Sun, 21 May 2023 05:21:22 -0400
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
Message-ID: <20230521051826-mutt-send-email-mst@kernel.org>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230512023234-mutt-send-email-mst@kernel.org>
 <6a900cd7-470a-3611-c88a-9f901c56c97f@intel.com>
 <20230518130452-mutt-send-email-mst@kernel.org>
 <dba3d773-0834-10fe-01a1-511b4dd263e5@intel.com>
 <20230519013710-mutt-send-email-mst@kernel.org>
 <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb44cf67-3b8c-7cc2-b48e-438cc9af5fdb@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 19, 2023 at 10:36:00AM -0700, Samudrala, Sridhar wrote:
> 
> 
> On 5/18/2023 10:49 PM, Michael S. Tsirkin wrote:
> > On Thu, May 18, 2023 at 04:26:24PM -0700, Samudrala, Sridhar wrote:
> > > 
> > > 
> > > On 5/18/2023 10:10 AM, Michael S. Tsirkin wrote:
> > > > On Thu, May 18, 2023 at 09:19:31AM -0700, Samudrala, Sridhar wrote:
> > > > > 
> > > > > 
> > > > > On 5/11/2023 11:34 PM, Michael S. Tsirkin wrote:
> > > > > > On Mon, May 08, 2023 at 12:43:11PM -0700, Emil Tantilov wrote:
> > > > > > > This patch series introduces the Intel Infrastructure Data Path Function
> > > > > > > (IDPF) driver. It is used for both physical and virtual functions. Except
> > > > > > > for some of the device operations the rest of the functionality is the
> > > > > > > same for both PF and VF. IDPF uses virtchnl version2 opcodes and
> > > > > > > structures defined in the virtchnl2 header file which helps the driver
> > > > > > > to learn the capabilities and register offsets from the device
> > > > > > > Control Plane (CP) instead of assuming the default values.
> > > > > > 
> > > > > > So, is this for merge in the next cycle?  Should this be an RFC rather?
> > > > > > It seems unlikely that the IDPF specification will be finalized by that
> > > > > > time - how are you going to handle any specification changes?
> > > > > 
> > > > > Yes. we would like this driver to be merged in the next cycle(6.5).
> > > > > Based on the community feedback on v1 version of the driver, we removed all
> > > > > references to OASIS standard and at this time this is an intel vendor
> > > > > driver.
> > > > > 
> > > > > Links to v1 and v2 discussion threads
> > > > > https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/
> > > > > https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
> > > > > 
> > > > > The v1->v2 change log reflects this update.
> > > > > v1 --> v2: link [1]
> > > > >    * removed the OASIS reference in the commit message to make it clear
> > > > >      that this is an Intel vendor specific driver
> > > > 
> > > > Yes this makes sense.
> > > > 
> > > > 
> > > > > Any IDPF specification updates would be handled as part of the changes that
> > > > > would be required to make this a common standards driver.
> > > > 
> > > > 
> > > > So my question is, would it make sense to update Kconfig and module name
> > > > to be "ipu" or if you prefer "intel-idpf" to make it clear this is
> > > > currently an Intel vendor specific driver?  And then when you make it a
> > > > common standards driver rename it to idpf?  The point being to help make
> > > > sure users are not confused about whether they got a driver with
> > > > or without IDPF updates. It's not critical I guess but seems like a good
> > > > idea. WDYT?
> > > 
> > > It would be more disruptive to change the name of the driver. We can update
> > > the pci device table, module description and possibly driver version when we
> > > are ready to make this a standard driver.
> > > So we would prefer not changing the driver name.
> > 
> > Kconfig entry and description too?
> > 
> 
> The current Kconfig entry has Intel references.
> 
> +config IDPF
> +	tristate "Intel(R) Infrastructure Data Path Function Support"
> +	depends on PCI_MSI
> +	select DIMLIB
> +	help
> +	  This driver supports Intel(R) Infrastructure Processing Unit (IPU)
> +	  devices.
> 
> It can be updated with Intel references removed when the spec becomes
> standard and meets the community requirements.

Right, name says IDPF support help says IPU support.
Also config does not match name.

Do you want:


config INTEL_IDPF
	tristate "Intel(R) Infrastructure Data Path Function Support"

and should help say

	  This driver supports Intel(R) Infrastructure Data Path Function
	  devices.
?


