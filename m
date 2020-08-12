Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F285E242E3E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 19:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgHLRqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 13:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgHLRqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 13:46:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80E682076C;
        Wed, 12 Aug 2020 17:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597254390;
        bh=rXcoDk9gtfvVEnCmNy1rAZyEXFA+hEFh1I5Kv8xj2Xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v5O44GKlgq291C72JNGazRYcN+6RHvge/gdLnu/APCsLGcNQ08dqsN57RUbYCjxXn
         zrZMX6cydZiYAbwK3k5XqIWZaDmMiYsh+gQhNjpIFnjLHgOodKp9JAjTJEFqmRQgv6
         ZrzCNq56Gyai7z9PhLx7EVxAKmcxGs0UIORMjri4=
Date:   Wed, 12 Aug 2020 10:46:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        lihong.yang@intel.com
Subject: Re: [PATCH] i40e: fix uninitialized variable in
 i40e_set_vsi_promisc
Message-ID: <20200812104628.340a073a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200812143950.11675-1-sassmann@kpanic.de>
References: <20200812143950.11675-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Aug 2020 16:39:50 +0200 Stefan Assmann wrote:
> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c: In function =E2=80=98=
i40e_set_vsi_promisc=E2=80=99:
> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:1176:14: error: =E2=80=
=98aq_ret=E2=80=99 may be used uninitialized in this function [-Werror=3Dma=
ybe-uninitialized]
>   i40e_status aq_ret;

What's your compiler? I don't see it on GCC 10.1.

> In case the code inside the if statement and the for loop does not get
> executed aq_ret will be uninitialized when the variable gets returned at
> the end of the function.

I think it'd be a better fix to make num_vlans unsigned.
