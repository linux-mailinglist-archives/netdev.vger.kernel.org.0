Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEEB74E18
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 14:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfGYMZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 08:25:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfGYMZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 08:25:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC059308339B;
        Thu, 25 Jul 2019 12:25:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3F151001947;
        Thu, 25 Jul 2019 12:25:14 +0000 (UTC)
Message-ID: <73cd7a2a29db5a32d669273d367566cdf6652f4e.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] mlx4/en_netdev: call notifiers when
 hw_enc_features change
From:   Davide Caratti <dcaratti@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
In-Reply-To: <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
References: <cover.1563976690.git.dcaratti@redhat.com>
         <e157af6e79d9385df37444d817cf3c166878c8f6.1563976690.git.dcaratti@redhat.com>
         <e007bac4c951486294d4e69d20f7c9ed7040172d.camel@mellanox.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Thu, 25 Jul 2019 14:25:13 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 25 Jul 2019 12:25:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-24 at 20:47 +0000, Saeed Mahameed wrote:
> On Wed, 2019-07-24 at 16:02 +0200, Davide Caratti wrote:
> > ensure to call netdev_features_change() when the driver flips its
> > hw_enc_features bits.
> > 
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> 
> The patch is correct, 

hello Saeed, and thanks for looking at this!

> but can you explain how did you come to this ? 
> did you encounter any issue with the current code ?
> 
> I am asking just because i think the whole dynamic changing of dev-
> > hw_enc_features is redundant since mlx4 has the featutres_check
> callback.

we need it to ensure that vlan_transfer_features() updates
the (new) value of hw_enc_features in the overlying vlan: otherwise,
segmentation will happen anyway when skb passes from vxlan to vlan, if the
vxlan is added after the vlan device has been created (see: 7dad9937e064
("net: vlan: add support for tunnel offload") ).

thanks!
-- 
davide

