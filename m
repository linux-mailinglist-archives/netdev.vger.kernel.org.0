Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19650C04E3
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfI0MNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:13:06 -0400
Received: from mout.web.de ([212.227.15.3]:34819 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbfI0MNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 08:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569586366;
        bh=9+EydTB3oaxIcqXkARAlj0ymKPOI7EPpnwruYTC7o68=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=KpcIuxCHIOEDdYU3C7H4pPgArCf79SXmLwQQ9tLKhmeBj2JiASJ4/zYdSdf65Qx05
         8/tl1YW+aeDwGdYeIjOwCMN8q+Lsr+GSWEcbRg+4o77nf2sOfQZbeyDXX+lkdUBL7h
         46gSte2tuylcW51K3LbBdJz9nLOoMwGbkJezklac=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.191.8]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MFt3u-1iQQ1L3sMY-00Es6k; Fri, 27
 Sep 2019 14:12:46 +0200
To:     Navid Emamdoost <navid.emamdoost@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com
Cc:     Navid Emamdoost <emamd001@umn.edu>, Kangjie Lu <kjlu@umn.edu>,
        Stephen A McCamant <smccaman@umn.edu>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Hurley <john.hurley@netronome.com>,
        Pablo Neira <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190927015157.20070-1-navid.emamdoost@gmail.com>
Subject: Re: [PATCH v3] nfp: abm: fix memory leak in nfp_abm_u32_knode_replace
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <1cde6417-5942-598b-3670-c0a7227ffe25@web.de>
Date:   Fri, 27 Sep 2019 14:12:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20190927015157.20070-1-navid.emamdoost@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GPpp/Jmguj5gZyRbIBBuNQg/VYufquVPI0YRXyh/rf1R1pyiu++
 oR+5VG8gbZtuvlPw75FBizPfqTOSTC47TlSQpHhIGg6xUGT3j86F1bEoe+CfaYQ+7fHjwMp
 mIuUeSsKsz2VUn5zrhC5Wd1HOHKISD2UNJU+Z5ZNBlRWb2onKshDqtVZgy+28ZLHkTJggEf
 AnPrRJeobakAZb+oZBnAA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:spUsCWq3aZY=:OdNvXllYytgX68EnEiCvkR
 meBLh6ycLl1ycT++iahSmm7dn6OEYu+bCn/ivUXljujqIRTCuiz99Bov09E2CVxJHGX3FS/P1
 G1rpkdfTMHIrPUNNB55NO3Spm/noVK31KAC38n4v3EV6WJBtad6mHYJRYh9iFr/qBQ1Lj73Yf
 HwlFNyecoOm9+6086p6nPoNkLcqHhOZ6Q3u8eLie6I3qsEi8thaRZDlcaZUewlnKE8oy1l8ht
 zolK90uBP4x6Z7LArO72l4/z7f1vtxCggk5IEO2/kPNYsOinZpQAQdIxzGsqa4Uqk9KBIQtu+
 REcFYoq4te//AffjIL6ttwuY8mXxDoTiQ9+qqMaJjJg2rN5K1w/AE6Ui/LZnyrW0Nr0OcvfBG
 k1rChuksl7c29bHhyH2vYvhy10DxOXW7+JKdQ8SuDImXHR8L4OSfjep8N4cZDSmwPSeIsK6t/
 92+0ZJEr9OKacUt8ZG1aSw2fO4N4GaPlqsnUbqv8oNEVZMEUEnedCiIoVCPzK3OB0GSRe3PUm
 L1WGwXDhIifO/Iql9bIoCuwh4vnziQzqclFAtAgjgVdcu8gK7sTUfyQ+GK2453eRBr56lOckK
 jxs17xZdTdz0rl4974kOQVay9vwotn4pv8nph1DxhuXojLXTfnGgfnS8UpH0WBrTOQfKg+hOv
 q4XXwU9uTdF1uMENehHnE60Guw6m5Q1yFozDYiSMFjlu4navuapxub+sOqhrrqZ6o5RgNMKo2
 DD0z6WmyYn7dktSxQg1fdI8fMbPbdNyEzb1S01xxiISf8y75e7nowitJm7AffJMi3/KX2iRYY
 vwV82Sd0FyMZfLS/2aSGt8tDsaGNzP/7/pYYOhFjQc8vvTgFvCtpE+Ebv/PZp41lA/YxgfQr5
 rrndxM69jDRULRxA+f5gMuiTQePBDkM0dTXTjC7twQEs+JZRTQ9795FlE3ZJB8ZqNL6fuunmv
 Yx5o1Z9l/zqImSv7zJdVq4x3sByoOim46avBUUk2P6Jj4kHrKmoR1+4vH/PnyMhOzB6BZK+VL
 W//ipAfBWo1GaaEHDT0yvKLrIygrdxdD4XjbxpcFwN9+9AIClwID3HtsxMZOSfUTTW87hzOl5
 FI13jBZbUtqnq+iBl4geW508alSLya/vfjvKQ8i0T88oiKu9r1SgxitmUvR/WPkETXv7Q2cFa
 ZKe8W0KBb2ilIxfyYqxdTqD7tQU00H+tTLmO8oj8sdLyHiWxNg/WCVrjZqVbWg46alqMG8CmU
 h+uffHUu/qXBHgODTJUKjOrIXRJ9j/2BdNAaidaXeoDdjNvmrvceETLejgr4=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Updated other gotos to have correct errno returned, too.

How do you think about to add a jump target here?


> +++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
> @@ -176,8 +176,10 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alin=
k,
>  	u8 mask, val;
>  	int err;
>
> -	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack))
> +	if (!nfp_abm_u32_check_knode(alink->abm, knode, proto, extack)) {
> +		err =3D -EOPNOTSUPP;
>  		goto err_delete;
> +	}
>
>  	tos_off =3D proto =3D=3D htons(ETH_P_IP) ? 16 : 20;

-		goto err_delete;
+		goto e_opnotsupp;


> @@ -221,7 +227,7 @@ nfp_abm_u32_knode_replace(struct nfp_abm_link *alink=
,
>

+e_opnotsupp:
+	err =3D -EOPNOTSUPP;

>  err_delete:
>  	nfp_abm_u32_knode_delete(alink, knode);
> -	return -EOPNOTSUPP;
> +	return err;
>  }
>
>  static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,


Can such a change variant be a bit nicer?

Regards,
Markus
