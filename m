Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A1554260F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbiFHDGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 23:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383296AbiFHDF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 23:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064B71D01CD;
        Tue,  7 Jun 2022 17:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDA86176F;
        Wed,  8 Jun 2022 00:32:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E4FC34114;
        Wed,  8 Jun 2022 00:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654648359;
        bh=jNkxr2BAMEST2L5uXoA5ARMOCBsjzOOvpJW56SQMXQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n71mFyQNTKYVixhcjdSQk8lnHen/GyWmdUWqXpo38ym2dUOw2HqSjlJfOnjfxEl3f
         smoOctgX3mfrIjcRO3oMuwRlzQwp4GAX/kcRmL2sXiTkH+mIYBXNDNcSpX4SMccf7K
         Z+6tAGmvNyFwt0T2fGz/R3VI7gycQLz4wt93fqKIO+xzc4Gv+9Jaqj4sVUsepwxzxg
         inDNjkcigu5pwOvi9Xo2inYl6xN+XI5qn953ScklseI50UpAqgJ+uUU76QHi6V2mdT
         zsmK174bCvCwj5oKlhJlfDQY5fX9PXXIENjbHZAAi4BI9Fl/tBI18Ly4WaeCYOAoAK
         Ou86CIBgznbNw==
Date:   Tue, 7 Jun 2022 17:32:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/2] bonding: netlink error message support for
 options
Message-ID: <20220607173238.1c92a95c@kernel.org>
In-Reply-To: <8b94a750-dc64-d689-0553-eba55a51a484@redhat.com>
References: <cover.1654528729.git.jtoppins@redhat.com>
        <ac422216e35732c59ef8ca543fb4b381655da2bf.1654528729.git.jtoppins@redhat.com>
        <20220607171949.764e3286@kernel.org>
        <8b94a750-dc64-d689-0553-eba55a51a484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 20:23:22 -0400 Jonathan Toppins wrote:
> Thanks, will post a v2 tomorrow. What tool was used to generate the 
> errors? sparse? checkpatch reported zero errors.

make W=1 ... builds will find them in sources but it's better to run
./scripts/kernel-doc explicitly to also catch problems in headers.
For example:

./scripts/kernel-doc -none $(git show --pretty="" --name-only HEAD)
