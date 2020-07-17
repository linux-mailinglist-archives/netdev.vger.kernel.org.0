Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665B722441A
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 21:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgGQTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:19:12 -0400
Received: from mout.web.de ([212.227.15.4]:36047 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbgGQTTM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 15:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1595013519;
        bh=KBBYg5jKhYtdb8avxOVNPB2JOheyh48NTKrDB6hfXp8=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=i4K38OYROzdresS/VIQlsE8MsV7TkvZaDXtyF+GYtmWM55qFfv4vV2POvJIrWUEzf
         bDHOIILEuRXOp5AYWHA+RMhgxndCagyVeYpOlrEuqWSTToTJ2vkRJ98Ni4GI7bBhgg
         cTCKrjOIcAfRPODLjYS73GjX2oLnO2UV4adN+uMc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.15.38]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MSJH1-1kPHAy0k2t-00TSSd; Fri, 17
 Jul 2020 21:18:39 +0200
To:     Wang Hai <wanghai38@huawei.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Vishal Kulkarni <vishal@chelsio.com>,
        Santosh Raspatur <santosh@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Divy Le Ray <divy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: cxgb3: add missed destroy_workqueue in cxgb3 probe
 failure
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <486de368-03d5-e168-038a-ae1506616703@web.de>
Date:   Fri, 17 Jul 2020 21:18:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yBTQ0ySiaUEGe/ZHc137uVzBVhYTmf430PoxbMtU+PpDRYoqryj
 n+cJUWq0GzP7EMVMv2w22n9DbFDRkmcuMz1kbKDfxlUMR0UqIoUbrgBnDSinCcfWXn9Bnj+
 kpnb5fJxtbYyCf5cRwzAsFKMRj+k4xAOZVdCJJnIfM2wy4sZnHlHNR/QBHnoLzfylMPQdvt
 UO39Y1o2tNLZEfnSZyFmw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:67j5l7m4e8c=:+H9RNahoLba1R4Yr+3gGQ9
 IYQDT+zPsGLWxfPvbW8w+BKj5htZiYZmD3g5rMGlYx59dwg5v4xPje6eAQDngA4DuiYF7M0K2
 8GCG/Jv0UaFQCZzVZtoMroG+u0Dc+jCS/00NViclPenltDQdXQA0VVnFnI04BiuIsgpraV5AI
 U9nxlHJDXbVIk86hhqSQlPWfE9ymQfXUy8LXbu9qtX6wtoQSi28lZuhqL0vbBNdS7L3hGL5RW
 i3wbp61AiC9f4/mHXY9pdDX/x82GhRAysTHfonWqi2109IMZw3hjuyB003rkG1MzgmI9K9z4i
 m20IkcEMw4V4zFcIOhYYU53Mc4oHcg6xSE27nnwqoe/S33+DcWPN4RYrryw714EDorT3O+A2Y
 GRQW3L+RRoxXnrF64y2Hj/rEpD39G14VO/StvljKf7c99mbXIOxy5OlDoNJemktHZmyScX+X2
 B2omV6ZV1ZQ816IkYeS4qHjCGtYmv9hgWPCXE8Ltm3n/f4uh3Dpm2c3y4i9jdbM+1r6lyMDcH
 dK/mAJpdMIsfZICy/9AXegI0Vl5LgPwV9AY8VJ8jqeFhwIXQcQcCzvIrt1LqvonUSn3696pPV
 BRUgT67VGL2Z5Pwt8d8IUuBWXCmv76zc3yaBZ5FjfHEwaL3ZclwRWQJEyQaFpc79Fg2CKkFIw
 ED4sAKkWXF2ozXbbsJ4hRqJD0kYQqqqJbqv9GW4VWxXo5h5gd8ONEzwO1uBwyeb8YKScHsIjV
 IJ2ZMUcI6KNOtJyZ4Rx25kcXW+BwuLvfM0dZ96vZsxusqX3gsByHGo08AHe5bwGNLIi4e3KPP
 8WL20OV3wWNFucnR2HH8asX9kVwnsqjkMqKoMLFNhb9aKC8X/eRlHLUanKhyDLV7a6+TU95dI
 kQX0WyLS0xiHTxNYCNZwGhJ+vqBAmELa2In6Nl11/AaXO6CpxuFVUCB8MiJPXDV2oLJYK5+Un
 n1UHPgpZqwHwsH6AJrwDrLhtR6pHlEWOBBphxnTEli18Inm5bwFLlXEiZoByag4S0e/48rDWi
 NaYPSrm0VAQrEhq56J7RwdVKTY9D+Mptol0EKV+g7u6gIImgLAKs7oVY9fezAoWNztelYv2em
 fKlWF0Vjywm6u9DTVEennl1BmfMCpFlTKR7IZP3Tg4/TbvqbzsYlfhVWoBDvel2AyRwMxkP4R
 /e780DwdocDusbZDVf7YsBdyxd3LdPa3a9DFw6QMuZLe9zWxJkcFmS6QOdPzCB9LYVRq+m4qy
 zO+AocVzIFBZ6N9yI3P0VjPqS7Ozb/56h+1jr0g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Add the missed calls to fix it.

You propose to add only a single function call.


=E2=80=A6
> +++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
> @@ -3407,6 +3407,7 @@ static int init_one(struct pci_dev *pdev, const st=
ruct pci_device_id *ent)
>  out_disable_device:
>  	pci_disable_device(pdev);
>  out:
> +	destroy_workqueue(cxgb3_wq);
>  	return err;
>  }

I suggest to adjust also the usage of the label =E2=80=9Cout=E2=80=9D acco=
rdingly.

Regards,
Markus
