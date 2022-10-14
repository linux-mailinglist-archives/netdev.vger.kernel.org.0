Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F6B5FF0CD
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJNPKP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 14 Oct 2022 11:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJNPKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 11:10:14 -0400
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11FA4AD6C;
        Fri, 14 Oct 2022 08:10:12 -0700 (PDT)
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BD2F40EA8;
        Fri, 14 Oct 2022 15:10:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 7006D1B;
        Fri, 14 Oct 2022 15:09:54 +0000 (UTC)
Message-ID: <a6d6e890c232775489daa9522c4f8dd9594b1656.camel@perches.com>
Subject: Re: [PATCH linux-next] iavf: Replace __FUNCTION__ with __func__
From:   Joe Perches <joe@perches.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        yexingchen116@gmail.com, anthony.l.nguyen@intel.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Date:   Fri, 14 Oct 2022 08:10:05 -0700
In-Reply-To: <2e38c0f1-1b6c-1825-12c1-5ad135865c0c@intel.com>
References: <20221011111638.324346-1-ye.xingchen@zte.com.cn>
         <2e38c0f1-1b6c-1825-12c1-5ad135865c0c@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 7006D1B
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: dtypu86bn6c75nfysogpch33x7cawm5y
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18Sa9ThNv6AzKDdzc7yh8rhUmyEb4/zKoc=
X-HE-Tag: 1665760194-585015
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-11 at 14:46 -0700, Jesse Brandeburg wrote:
> On 10/11/2022 4:16 AM, yexingchen116@gmail.com wrote:
> > __FUNCTION__ exists only for backwards compatibility reasons with old
> > gcc versions. Replace it with __func__.
[]
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
[]
> > @@ -4820,7 +4820,7 @@ static void iavf_shutdown(struct pci_dev *pdev)
> >   		iavf_close(netdev);
> >   
> >   	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
> > -		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __FUNCTION__);
> > +		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n", __func__);

Trivia: I suggest

		dev_warn(&adapter->pdev->dev, "%s: failed to acquire crit_lock\n", __func__);

As almost all printed uses of __func__ use a form like

	<printk_variant>("%s: message\n", __func__);

not

	<printk_variant>("message in %s\n", __func__);

