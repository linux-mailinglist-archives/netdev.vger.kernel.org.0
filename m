Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2674A55FF
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiBAFCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:02:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56478 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiBAFCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:02:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEBC4B82CEC;
        Tue,  1 Feb 2022 05:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E6CC340EF;
        Tue,  1 Feb 2022 05:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643691730;
        bh=pqNrAJYzoXsKukFOIumUYolAMg6fjd282YRHNnKXT58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hSgqVzbgwPhOmPyttp9T/sRLd6qG7vExPDGFaVkgujJTemvPlJw6RSRdwuvdXylE5
         Y1ejmwXdoH90BWZJuN9l5haxlgb1Qhyx9f4qrVti6/xmP+8CMuW/A9Rhi18z2YnjrI
         R6RrAlWXo0hisQf6RN3qwZTzOt9FB0xzrAMhObsiy9bfkSlOuUSBX88qBXUK1nVUJM
         K4cisZTxLgNv6xdyR+fgNqLL7IzgLiYGmeuJz11YGYM+SaPVo8QoxX3a90ciSTJ2TW
         gVHGxJEJ7j+z450h3+TylYuRJpPgZAPc89t/S8JprsDkY/de+Dd43NPM7ZPCFJPo4M
         JQhsdOhteOlTQ==
Date:   Mon, 31 Jan 2022 21:02:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, tom@herbertland.com,
        zeil@yandex-team.ru, mitradir@yandex-team.ru
Subject: Re: [PATCH net-next v5 0/5] Make hash rethink configurable
Message-ID: <20220131210208.69c671de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220131133125.32007-1-hmukos@yandex-team.ru>
References: <20220131133125.32007-1-hmukos@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 Jan 2022 16:31:20 +0300 Akhmat Karakotov wrote:
> As it was shown in the report by Alexander Azimov, hash rethink at the
> client-side may lead to connection timeout toward stateful anycast
> services. Tom Herbert created a patchset to address this issue by applying
> hash rethink only after a negative routing event (3RTOs) [1]. This change
> also affects server-side behavior, which we found undesirable. This
> patchset changes defaults in a way to make them safe: hash rethink at the
> client-side is disabled and enabled at the server-side upon each RTO
> event or in case of duplicate acknowledgments.
> 
> This patchset provides two options to change default behaviour. The hash
> rethink may be disabled at the server-side by the new sysctl option.
> Changes in the sysctl option don't affect default behavior at the
> client-side.
> 
> Hash rethink can also be enabled/disabled with socket option or bpf
> syscalls which ovewrite both default and sysctl settings. This socket
> option is available on both client and server-side. This should provide
> mechanics to enable hash rethink inside administrative domain, such as DC,
> where hash rethink at the client-side can be desirable.

This appears to be 01b2a995156d ("Merge branch 'hash-rethink'") in
net-next, thanks!
