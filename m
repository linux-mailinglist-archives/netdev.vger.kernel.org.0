Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9866D5537
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 01:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232745AbjDCXab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 19:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjDCXaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 19:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE696118
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 16:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60F262D9C
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE88C433D2;
        Mon,  3 Apr 2023 23:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680564627;
        bh=pZArOfDnQ6kQlIKZx74Cr/CYk/MKaLaNiAeOKGr+SLk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q0YcpWtMQCZAvQm4e5uID3gEYCsbXeHO6jVnsbkRy5hUC34LT9ei56vE225BKDlOr
         KOPU3/hJa+/lcTlIV+1WNyphm1RoSCpqhiY36ryj+nQbo59CPuk3fopDomqrdOxCrs
         KevviXjPvyVYpnuxRtkRI6RbKeWz7J6/NzEy18MOcphr50OugzpD1VkKsmUwm6CEyE
         lcIxGv84/s4TMd0sf6eNWteyzksxhBmONUojssbT15k/VvyilUIhzcnl8gGC3M/Ice
         cE8KFl85ZpeWMMfPZPDkM2zwpPbJthioNR1gN+VQNoMA+kKa5M7FL0LHbTFolrxHRP
         o/bwvuJACQRPA==
Date:   Mon, 3 Apr 2023 16:30:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Message-ID: <20230403163025.5f40a87c@kernel.org>
In-Reply-To: <eb945338-915a-64cd-52c5-3d818ba45667@amd.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
        <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
        <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
        <20230403152053.53253d7e@kernel.org>
        <eb945338-915a-64cd-52c5-3d818ba45667@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 15:54:33 -0700 Shannon Nelson wrote:
> > The noise about this driver being "a standard" is quite confusing.
> > 
> > Are you considering implementing any of it?
> > 
> > I haven't heard of anyone who is yet, so I thought all this talk of
> > a standard is pretty empty from the technical perspective :(  
> 
> Just that they seem to be pushing it to become a standard through OASIS,
> as they infer by pointing to their OASIS docs in this patch, and I was 
> under the (mistaken?) impression that this would be the One Driver for 
> any device that implemented the HW/FW interface, kinda like virtio.  If 
> that's true, then why would the driver live under the Intel directory?

Fair point. But standards are generally defined by getting interested
parties together and agreeing. Not by a vendor taking a barely deployed
implementation to some unfamiliar forum and claiming it's a standard.

I think it should be 100% clear that to netdev this is just another
(yet another?) Ethernet driver from Intel, nothing more.
Maybe I should say this more strongly, given certain rumors... Here:

Reviewing / merging of this driver into the tree should not be
interpreted as netdev recognizing or supporting idpf as any sort
of a standard. This is our position until the driver is in fact
adopted by other vendors. Attempts to misrepresent our position 
and any claims that merging of this *vendor driver* constitutes 
adoption of the standard will result in removal of the driver.


Is that helpful? There seems to be a lot of FUD around IDPF.
I'd prefer to stay out of it.
