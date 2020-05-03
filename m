Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4BE1C2BB5
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgECLam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 07:30:42 -0400
Received: from mout.web.de ([212.227.15.4]:47341 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgECLal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 07:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588505420;
        bh=ZfR/j8FzIXQ40geuJjkx72Nqy0w37sA/9k4Ot8IruFo=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=an+oPgSNFp8kgqFZrPRhQLDwUFqtxB3WnW7lzOOHJCTFgREKeJVeeUy6QOaxtZdPn
         s9q6chxoKMMaZEcqMiS3uTqMBV8GzH1BeVM8kP7rzSOzvuVv2fWI9zYmSwtjxh9V7g
         e9hGYvkqcD9acxzugzZj17ptLs+g8DbJVuFw5Pv4=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.26.31]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M5bEe-1jFkNH3mkC-00xcT6; Sun, 03
 May 2020 13:30:20 +0200
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>
Subject: Re: [PATCH] nfp: abm: fix a memory leak bug
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <75768a26-836d-2aa5-94c8-6d8183745a9c@web.de>
Date:   Sun, 3 May 2020 13:30:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:u1OWjvm55dXZxmYL+qlxpHxoxhehLFicR6L3MkhYNAQTVrjI7a5
 aRRITsWkXM1efYpfkLfuRoJ+nnfna1f2Q4fnI6ujiunlFWb/ZIgAe3W4ABvpOxCdShM2CyK
 UykMfYmiqvAgM9lHIqY4vfP1XhGlmmlzzQ6b+giz3U1WSax94DhAxTgTJIyneejnzSyzl3t
 akNhTpY45wo/+Ex0jPbxA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:R2aKBlD2Bms=:ckg9H4bnNLS86075gaqFUR
 7sganYzDW7j/ydhpob/5o17FpxGq7hBm1DFxSYMrdIQtYWoKKR7pirLJTVDMnpWd1D8UaCyFT
 KRT1R/I0r4HlZLAO261p2/MgGgJ8RdxXdoC/gTRvLvJ6FpSy6TupW1Vcuff16hj8wPcN3gtEz
 /ZwTkLo7ih9pDa4fUlvM3jBHaxEJdKhGjQQo3Uu2oRGDLWJCW+F52qOZRV+J8dlWqCH5KzWJP
 Y3v8nPovO7OKND1WbcGBQRMj5YbCS2YdBDN1uGjV10d1ncNzJQTcS0p3OumO2okG1b910xn57
 0sr9BIokeaNmsA5psnXA9FBKAwnVYiXh/BkPw13ggJZ6oTfMHO+QrAEtVPiaT0nhKG795r381
 ZyJNf0/yeV7ec4yMGmd4fuTzcU3nEDERdkpsmZnhJkfcNLL7ps5krH1t3IsZ+ZUKj7IO7/vau
 nnqCwPacLvMe/I39bc0xizuXK5pojbH5LjGc9SC9r6Eu0BwACgb8tZgPv1A1Aphe0x6lN79EJ
 lsnSo6IxCNDYCtvdg49/HnhM1Sg88gchqj0bDAjmEv1HquCfY7E3pCgiT3ArLtXIL7xuvuQP4
 xdTPYsGyDkhYV1V83pMzBoT0zoQ2embLNaA7Vj+6j9hk0sJRz1DB2bR9ndgOzH8nzEUQ9P1mP
 G7UZC3EYgyOCE0i/zGYupJw2TQhgEuxothUtGXeehmyR/HKzYGonsUMoKn4FOKUMwLhTK1fyu
 XRzLHREqAkFKofpgX2DO/vJgoMPwbObnGMU0DMFh3o5/VeGwRjSX0RIhtb53U91wwh06fvfKV
 46zgYsndrA/t56Ss1dTQJy0nlGdc237L5iM/asUWzh3tzv3t5Xy0x+xwWn4gM+BoUPhRHcD7F
 6yyk8TxfNeTedLdQKz0Bq3lu51ZObsAs9SPXsLpqRojiQowintRw2e20yeFMjPwAIicry4KCs
 bCKxKC2VIBCM6YwjgUSOKxhpLbFKaJibEYZn8INjpzNmkPOoCQm9NSvtxQ1PxrLChnvIJivXJ
 54SPdfVrCd/sq3IlMh6mc3kSjlBLGFQ2kIHGk/obJGpdKMGog3wA2QnXbFrf1odOf83cnA8h9
 r+9msToOLx90nG6hh8Lf1MtmVvbvmXeQJdwjH0hu/1sFVR65m7G0YjEMs6up2/vhdZMK9ouRW
 fAidqpg/Wt4Hce0hcv7rcRv2rUMPbS8gIiURpqRYWSRgAqZpoCE5WAsKxGzAX7cUCP7ix/Q+n
 YmUEv3fvCLoBYv6cD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=A6
> Fix this issue by adding nfp_nsp_close(nsp) in the error path.

How do you think about a wording variant like the following?

   Subject:
   [PATCH v2] nfp: abm: Fix incomplete release of system resources in nfp_=
abm_vnic_set_mac()

   Change description:
   =E2=80=A6
   Thus add a call of the function =E2=80=9Cnfp_nsp_close=E2=80=9D for the=
 completion
   of the exception handling.


=E2=80=A6
> +++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
> @@ -283,6 +283,7 @@  nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp_=
abm *abm, struct nfp_net *nn,
>  	if (!nfp_nsp_has_hwinfo_lookup(nsp)) {
>  		nfp_warn(pf->cpp, "NSP doesn't support PF MAC generation\n");
>  		eth_hw_addr_random(nn->dp.netdev);
> +		nfp_nsp_close(nsp);
>  		return;
>  	}

I suggest to reconsider the order for resource clean-up function calls
a bit more.

+		nfp_nsp_close(nsp);
-		eth_hw_addr_random(nn->dp.netdev);
-		return;
+		goto generate_random_address;


Should such a jump target be added in another update step?

Would you like to add the tag =E2=80=9CFixes=E2=80=9D?

Regards,
Markus
