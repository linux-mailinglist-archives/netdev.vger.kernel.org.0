Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4793148930B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 09:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiAJIIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 03:08:17 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53744 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiAJIIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 03:08:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CECACE127D;
        Mon, 10 Jan 2022 08:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B72C36AED;
        Mon, 10 Jan 2022 08:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641802091;
        bh=PnoU2Zz1OK3gxh6Vjy12PzEUe4rZHQBJaKNe/vb3GSs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KdPFkR/3ZvDQlrr/md1l5hrX2u7l7pjgz0YHP4afAFrvdIW+zl/s0sHXHc39NQPEg
         w+KE7IHSOiYA4uogkQaJxSDuk80k/ZVNdvfoGPQYVdCErJz5ngCTSHjH4LFQWBAnb+
         afPxNm+y0plBZpHsmPMbOmXNRVVlvDrmiHc1JQEZXFN0owAGEDi++I5Hm2gLfJPMzo
         8j8USbb9tqYBjKMy4CEQ9D+VCtkn0MhdClDysCMPgtppPnhIWveECDm2KT9DgT9yFc
         X30pYzA7kxF3cDLgDSCrMrbEoAjR2gxRIqRKzaUk7F5O80mP1Hr389N2/L4deoX23t
         XNV6vaUY5LjYQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     nathan@kernel.org, johannes.berg@intel.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        luciano.coelho@intel.com, netdev@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()
References: <20211227191757.2354329-1-nathan@kernel.org>
        <20220110003326.2745615-1-kuba@kernel.org>
Date:   Mon, 10 Jan 2022 10:08:06 +0200
In-Reply-To: <20220110003326.2745615-1-kuba@kernel.org> (Jakub Kicinski's
        message of "Sun, 9 Jan 2022 16:33:26 -0800")
Message-ID: <875yqsvwrd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

>> When building ARCH=3Darm allmodconfig:
>>=20
>> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c: In function
>> =E2=80=98iwl_mvm_ftm_rtt_smoothing=E2=80=99:
>> ./include/asm-generic/div64.h:222:35: error: comparison of distinct
>> pointer types lacks a cast [-Werror]
>>   222 |         (void)(((typeof((n)) *)0) =3D=3D ((uint64_t *)0));  \
>>       |                                   ^~
>> drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:1070:9: note:
>> in expansion of macro =E2=80=98do_div=E2=80=99
>>  1070 |         do_div(rtt_avg, 100);
>>       |         ^~~~~~
>
> Let me take this one directly to net-next, hope that's okay.

Thanks, please do, I was offline for a longer period and just came back.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
