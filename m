Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968162D491C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732125AbgLISf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:35:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbgLISfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 13:35:18 -0500
Message-ID: <838391ff7ffa5dbfb79f30c6d31292c80415af18.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607538877;
        bh=3X/D5hvu7Mw8OI2N0c+ZBcM8uHhfymhfnzDJcez/ay0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rMHgSeDAzDmTrDs5j7NtC9mePdMVmKOuTpOW5qqN9TaG3WkOErubDYLJ+gvBFZmTs
         FtpSoIVaoazhwQuCzTrFhRFA2P79IGpkuRyzrFko7gICCEZ/BAm8XLObFPPwHXz+Uu
         rFIZUuX+rKf1dEcgx5BLDMSt/qyJ1udTpubrrt/hic3yVF4+20rUVRadajNwOFu9jM
         dYxQvB0lnkPqDC5GZ5zuiUash+imDAEPqaIZefdFeoIMZiyoKVZSUaAlD0EkfZQMIN
         48PzNvX6gOeK2aHYLahWCpVPM0bchtNn4z/SF4i6vFhKNWEQo2+2qImNmpGVUmAiYC
         XWfulWMFMBYeQ==
Subject: Re: =?UTF-8?Q?=E2=9D=8C?= FAIL: Test report for kernel 5.10.0-rc6
 (mainline.kernel.org)
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladyslav Buslov <vladbu@nvidia.com>
Cc:     Jianlin Shi <jishi@redhat.com>,
        CKI Project <cki-project@redhat.com>,
        netdev <netdev@vger.kernel.org>, skt-results-master@redhat.com,
        Yi Zhang <yi.zhang@redhat.com>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        Jianwen Ji <jiji@redhat.com>, Hangbin Liu <haliu@redhat.com>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Changhui Zhong <czhong@redhat.com>,
        Xiong Zhou <xzhou@redhat.com>,
        Rachel Sibley <rasibley@redhat.com>,
        David Arcari <darcari@redhat.com>
Date:   Wed, 09 Dec 2020 10:34:35 -0800
In-Reply-To: <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
References: <cki.4066A31294.UNMQ21P718@redhat.com>
         <CABE0yyi9gS8nao0n1Dts_Og80R71h8PUkizy4rM9E9E3QbJwvA@mail.gmail.com>
         <CABE0yyj997uCwzHoob8q2Ckd2i5Pv1k+JDRbF3fnn11_R2XN1Q@mail.gmail.com>
         <20201209092052.19a39676@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <CANn89iL8akG+u6sq4r7gxpWKMoDSKuCbgFvDPrrG+J85zC1KNg@mail.gmail.com>
         <CANn89iKcKATT902n6C1-Hi0ey0Ep20dD88nTTLLH9NNF6Pex5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-09 at 19:05 +0100, Eric Dumazet wrote:
> On Wed, Dec 9, 2020 at 6:35 PM Eric Dumazet <edumazet@google.com>
> wrote:
> > Hmm... maybe the ECN stuff has always been buggy then, and nobody
> > cared...
> > 
> 
> Wait a minute, maybe this part was not needed,
> 
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index
> 8ae9ce2014a4a3ba7b962a209e28d1f65d4a83bd..896a7eb61d70340f69b9d3be0f7
> 95fbaab1458dd
> 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -270,7 +270,7 @@ static void geneve_rx(struct geneve_dev *geneve,
> struct geneve_sock *gs,
>                         goto rx_error;
>                 break;
>         default:
> -               goto rx_error;
> +               break;
>         }
>         oiph = skb_network_header(skb);
>         skb_reset_network_header(skb);
> 
> 
> > On Wed, Dec 9, 2020 at 6:20 PM Jakub Kicinski <kuba@kernel.org>
> > wrote:
> > > Eric, could this possibly be commit 4179b00c04d1 ("geneve: pull
> > > IP
> > > header before ECN decapsulation")?
> > > 

We've bisected an issue in our CI to this patch, something about geneve
TC offload traffic not passing, I don't have all the details, Maybe
Vlad can chime in.


