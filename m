Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E00F41C0940
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgD3Vak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgD3Vaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 17:30:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24DD1206D6;
        Thu, 30 Apr 2020 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588282239;
        bh=E1il3KMJxOpcK8bLPPRsn00lhrGKUIAdgEJw2RM8naA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ClUYauQaz62ZW3jP58Y20x8r0dm7Jv3T0A4vEqo4uFrUU68AZYTzRK1c+XQPdJ2JB
         m1FnZc1q7TEvEYtbHy2SwbwVFzVvf//wM0C975+JHvrsqhaJn6qprKUY8gLXrhNGCI
         hsNNYnyFn+2CwzxS7jyGqBj3eZBsnqLaMUSmp2ss=
Date:   Thu, 30 Apr 2020 14:30:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v2 net-next 15/17] net: atlantic: common functions
 needed for basic A2 init/deinit hw_ops
Message-ID: <20200430143037.6e063414@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200430080445.1142-16-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
        <20200430080445.1142-16-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Apr 2020 11:04:43 +0300 Igor Russkikh wrote:
> +	if (hw_atl_utils_ver_match(HW_ATL2_FW_VER_1X,
> +				   self->fw_ver_actual) == 0) {
> +		*fw_ops = &aq_a2_fw_ops;
> +	} else {
> +		aq_pr_err("Bad FW version detected: %x, but continue\n",
> +			  self->fw_ver_actual);
> +		*fw_ops = &aq_a2_fw_ops;
> +	}

nit: I assume that setting fw_ops to the same value is intentional here.
     FWIW it seems more readable when dealing with multiple versions of
     things to use switch statements, and the default clause.


Series looks good to me otherwise.
