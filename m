Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B6424339C
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 07:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgHMF22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 01:28:28 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:36923 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgHMF22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 01:28:28 -0400
Received: from [192.168.0.48] ([217.24.225.235]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MA4ja-1k04A53B4U-00BYAn; Thu, 13 Aug 2020 07:28:11 +0200
Subject: Re: [PATCH] i40e: fix uninitialized variable in i40e_set_vsi_promisc
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        lihong.yang@intel.com
References: <20200812143950.11675-1-sassmann@kpanic.de>
 <20200812104628.340a073a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefan Assmann <sassmann@kpanic.de>
Message-ID: <282db652-e9a7-d7be-1f9d-9434c11323d4@kpanic.de>
Date:   Thu, 13 Aug 2020 07:28:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812104628.340a073a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0AN9FO5BzAlQft0r3CQlN/YuAV8tUhrMf03DbcSTVncgzgVcbIO
 pzlI7by81gYk5b+8izTS50j9TzI/eb4TyWuSf2Q3fd7M1DYWpH6NCnDL5kDJgJclxOVDVQs
 5yloOECMlm1Zg/ObGfChfFNwQc8RpNaA+byji2EIJ0H5qzBB0OupJwfHgSJQqYjAzgAS+7y
 1fTmvMWdx7W2+8/mzctqQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mFtHPJwNkTs=:KoLpRyR76n8+4psUo3MChd
 H+WZhpVBfFnBE1O6sSCAxGFBOSKy2NUURcHE5owKJkODf4CDwNz7a0TqFNcIib9I1fXz04F9L
 eXchRl7DoKuNV8MIgMRcpsTNI5nImlmiXguXa/qlXpmRiSu7zSbAFEbAPgPRrQ8ewuDOwBm7g
 XCGExOUgRBUCwnfAoDI1Kw1FHxOdqZ598hBTmeJjO44ywq060V/vprD4Eu4w/usb7dzVP554B
 Zmw9x7nz851vhITrairXAwx37G1mc+aqoycXsqdIwXag7bX1ekDcYn0/wu6VyVG8/flp/QBGC
 RI48ftIOvaB+yblFVVtKWRQeDRWWXqtK9loLLPV3zI5tNnKtYySEeqZ/yViDPD+tKMlck49zo
 xSCkDZCkHSqLhU8KV/Q2GaDeJbMOiOJ6nfr3QynRhJ+ERhFdVii8zoaq5rlOnkMIjO4LR9HsT
 +RHazZiRGnPiWf0QrbBoCGs2/bblYcn6WvwDe9Y1z9Ukhy9p/s1SsUNiexWiqX73dnXcOG8pV
 qz9M5+02k18YgrF+zrLL/L+ux/crevda/Jv8iGFe3zA8dM70PmIMlzx2+Lfmpr5ERhWIdMW7z
 gym3KpJ0dOu7EfJFhxGi05R+OeR5bEV2KM37cOakuhVyuDTfSgWtNh6Q0lVDoYp5tFPh8mq0y
 4V7lR7yitSl5thEUELmMdRGYpTw0EylD1JK+E2sHCnXkfVRezcBNydnNTesxj4AUp9Qqz2XKb
 N3va6fpjsbgm7oJHE1HgQzmI9BtThoyDTdjrEz0Rzvq1jqCnFS88ZQJ7pqu0tMljT3qqA2NCL
 VPIL1invo9X2fqS/Sidj7sk9P2T4XnkZ0KHd1DTXcZEJrNkNhab5YYN+aKgxtt7yNjsY/zr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.08.20 19:46, Jakub Kicinski wrote:
> On Wed, 12 Aug 2020 16:39:50 +0200 Stefan Assmann wrote:
>> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c: In function ‘i40e_set_vsi_promisc’:
>> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:1176:14: error: ‘aq_ret’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>>   i40e_status aq_ret;
> 
> What's your compiler? I don't see it on GCC 10.1.

gcc version 8.3.1 20191121 (Red Hat 8.3.1-5) (GCC)

>> In case the code inside the if statement and the for loop does not get
>> executed aq_ret will be uninitialized when the variable gets returned at
>> the end of the function.
> 
> I think it'd be a better fix to make num_vlans unsigned.

Agreed, I'll send a v2 patch later.
Thanks for the review Jakub!

  Stefan
