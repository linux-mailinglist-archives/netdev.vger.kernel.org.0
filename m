Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400784088B1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238905AbhIMKDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:03:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60846 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238444AbhIMKDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:03:52 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18D6hcnU006265;
        Mon, 13 Sep 2021 10:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=gJLk3CDNyMwwEr4ZnpqbAU+vyy3WN725fbNjq7hLJt8=;
 b=ZAMuxWXrHyIG4pXxiU/XEG91vAGf4yPO7uZwdNja3q4xgZjeH8OqwkaW2FA0+twfTKrN
 D4HniT5d40ve5Mhr9W0nDtDEzQvyyvGLWjx78mXf0mt1lHOaVaZcAGSu4rnOXn+b8ZiI
 UWZVQRvZkNXgGsiUcvkRKH/3OMY8OF/Lhte/ygYSaUUOaoncspGpjLoBcaktwdA4X0tB
 0sU0nZhSdS5KGhJmmiLzl30hAXrdPlYyASAqcjsM7M2vURG8q/A/5h8kUURAl/h4ILoW
 LyV31ggCgHNQ5CK69/oyHkkzSvmaKCa+UW6bUizx6VyaM7Jad6xV+IW2m9DdO1RCWUKf bA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=gJLk3CDNyMwwEr4ZnpqbAU+vyy3WN725fbNjq7hLJt8=;
 b=ZKPyJpygxXVm2/6wnFXsYcDkgBYtFIdRNPmzHNXFT5SFLzG7vmVKlLD5CoJJqSl5XZuA
 tdDJND+sykPttK9HK73a1bzWaafLG8xjNVyu5KVqNbLBj+TwBU25opxzDZBsOAO2l5bS
 b0QPv2JEw3MiLTqvT17B6dPSUefumgn267E/FI0LJdTLwWotjL+1pjADP1zHTh09ulFQ
 p7eaog4o1r8ge/2N4300JF/83XYzDRpqOgtJN53kUuxW0n8DfHrbvSNUVLctLPXACuOr
 D0C1T0AbiNp438GR5BaGw1GMgGj4zWjqIvGndbHBbBQGAyYuzn+kPm54H3f4EYvaxjy+ CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k8s9xyr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:02:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DA0K9M098676;
        Mon, 13 Sep 2021 10:02:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 3b0m94g6p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:02:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFnNWnQRS+Knhrbdseune4P/YuzGQ6PaNqJwq3cm7eSFFNJ2gXvj/6boHIaGZpFfpaE9HB+3pYIH4YYWvu3ptwLgmPr7tKnpQfpO5nK/fHYlc+nQuE3iNZLb7EFR/vzdb4vfsCqax7S4rl6qEgTFpfQ3Z4XW1ZLXuPGTUIwiBo6m9T25bVG/E5o+ukdAz8uc7J5sdv61rAjLSeZ0ug9dNlekOIQzgCvDkB+8ZFPGenuZI0zAXhNsFmUKBb0jVLuQWxS9v0BoQHQHV4dTvWZM0BXezlIErDAKAgeshVv8AYJ2vBYbfcQIxi+nyK9Oix3LWQIZD1+OrV+BGgtPCdojjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AMORkzjrbpBsSuzAfnNgvLw7n+wyQQ6AqDDXYT3rG9E=;
 b=QxNGqlr5EHFFN1sBSn/TgD85XAfJjSM8cY15Js0BBVrzU+2VDgkfpU9s/2XXHW45zD+tNhEEzq7f1OqoXsYd7cMsIaskCIQB5zDq3TVj4Dauuzv5dVTMmq6NEEhq+ufe6yy0I5NsaLTaQNEqDvmceR6YTF155lK6vzVA8dRCb/MhwTLBjRrHaZ6nerCAafZoWhxzzpiN0ogDQraR6ZvZ65/WXti0c0pKfCEq8qBbOjqcA8x1XnYhu5muuQMzaOfANyAQV1kWTqQ8+nx6GSwGsO/Swg7fan/XNicjjZWWNBw96R+UrTAOKQiMkG5gEPu6zBL2HKyqdX9elfcdKpNyJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMORkzjrbpBsSuzAfnNgvLw7n+wyQQ6AqDDXYT3rG9E=;
 b=ixieC2wvGK/rCwtwWsmg2GGwt/18uwi1Nl5oYNZf50MGqgcL62hGYmFAFUMjNvrSUlgLO9Xb39eoMD/PFtZmGFCu7BPqP9gSu0OhmmLlXiTzkCm+z0nbd0twOgRcLHkt7EFsEtK9ah1Scnpwa9e4MgkYe3LhHI0voS58+ushJu0=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2253.namprd10.prod.outlook.com
 (2603:10b6:301:30::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 10:02:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 10:02:23 +0000
Date:   Mon, 13 Sep 2021 13:02:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 12/33] staging: wfx: simplify API coherency check
Message-ID: <20210913100205.GI7203@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
 <20210913083045.1881321-13-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210913083045.1881321-13-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNAP275CA0067.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 10:02:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1691eb64-bee9-4c30-b723-08d9769d94c1
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22531D4E9C33646AE793C9F78ED99@MWHPR1001MB2253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cF7cSpzbWfIBu30Dmm74SpKZcSSMs7LPLc6QLGy0hVbgTJjQ+AaLLFgFYf7CzG9B7H7dNOLdCwJqWmnqI0tYKwtxDHlDcZtM0F1I0Hm9z3cLgzHmu8DnB2qdwTRZOY/RITw4cncl+IrcoQKrCPMUgDJdpDZ42fgFC5fA2nKSU9u+tyqwB2sxNaU2lFQai1+v6a0GplHQPIMzhMKhRrsxSfU1jRB+F1qlwmtmDBEMMJMCimZTgGEu0j9yPeCFitXMYltsbEdys+jqb5KfrvysF95981Ozi5UnN6M9uPGq36g3O2ixbISgyUo82wBIwI5uX49WJznG+BAN8OY3GWCFvgF+L1DzY7yTejcWqi6uvguS32ZYufS4Zjvp+TyhO5MbeBjI4u1jfyRlZp2MLBsQz9uQe81ZKpmsR+yoI3cYh/PbiPT9676+Buz6tL7xIMJqcWMkzMp1K3HA6P2qkm8B/OxTmCATTuguYK0yb3M0LIy14yOLGt/23kdBewM0JghUfm6QeOomEw2X++s/SXOFClVIWWkbPRS4ZceNywEXjIlFsyZJN8DEItvFDX68fz/3Jz3zEA2rc0kHJ4rOh0tAjxE9XfcSfOuw4O4l8hJmI+YudlNaUGm3GA+KHt3Q98hN0xRHoo1WBtDywho7S4KjnsTUDxMvF4hZb7rG3l9+ag0+Z+ZBjudvdu5HR1OXXZmeb7F/wu+gBZn9Iy8wK3btfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(396003)(376002)(346002)(44832011)(33656002)(33716001)(86362001)(186003)(66556008)(66946007)(66476007)(26005)(9686003)(83380400001)(38100700002)(956004)(38350700002)(8936002)(9576002)(316002)(478600001)(4326008)(2906002)(6666004)(54906003)(52116002)(6496006)(5660300002)(55016002)(6916009)(8676002)(1076003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?YeLBaXRcv8QglQXjwwDDx5Ao/Fi3p73hYlU20Plf+XoKtv/6cvp0rfie/I?=
 =?iso-8859-1?Q?jO0vT/F+yaxLykD66TFExRjQt7R/2f1Ii6K0t3OSe3SS/NTLmDLGB5dOXE?=
 =?iso-8859-1?Q?v5krOzj6+xh6F86Wii2MAVLC7uDvyYjiBhq06FZBJmCyDawl5fJcEbQ6Kq?=
 =?iso-8859-1?Q?fwxLJJDU6/DXdH5yLa1UREhGiTXxbk32vsFIOrT/F/Cinp7s6rtsNH/9qg?=
 =?iso-8859-1?Q?psUKNBvg+Gf4nau1UfRASVcPTwyQm2Sclqg2KARqIJ1pqO4LNRmj7MnVd2?=
 =?iso-8859-1?Q?dcOdTYqMqrOfpZyA8oe28d051Ilh4JuFUo/GbmrGUGTh6eMxufBdNdfTvz?=
 =?iso-8859-1?Q?+ISlMaNeAlUXn7O5/AQu38riQEIwWhOzkqDF0a7zK5ovly3nu0aAxyGJxR?=
 =?iso-8859-1?Q?BKzyhh+yYrIpZppRn5K6eYRi5hddZuJu4jRO5hRsmqikDOWqj1dOPHZvRM?=
 =?iso-8859-1?Q?5L6Y8mX+S8x5GVyOIq1YGBX8Y3nHPBUxrjr3LQDecRZANV0WQp8Kem6djI?=
 =?iso-8859-1?Q?UoyVouxs4s9SZMPX3lOKbcsZ30rRCskMQErfHJYEoQ+ZAd7XPhPXWGuw93?=
 =?iso-8859-1?Q?hAsJOkSLQdC6JmO5E2HjapHVvRiRlwND+Sk17tnIs/7QCPkmXQGiA0Kq4/?=
 =?iso-8859-1?Q?ij1iviTyuBbrJ2R3SNLfHhYV8nHsAFW31oqlROK7lRl17yV0paHKR7Veyy?=
 =?iso-8859-1?Q?lL4+BP90EqjbhQ69dyyByudaVF8VAvJ8v8VpcJe5Bhd0QiegDk6TRFeodW?=
 =?iso-8859-1?Q?wtyZe1Eh9H0FDKpwu0LmbteFQuAx5bB4H/ueVEiLSx6ZcewSw/DYCwXxoG?=
 =?iso-8859-1?Q?SPTs+BM62oEtUj+tSVBnDQuRm0LQEhhKAoeFaK91Z4t2oTnPIQJpG6Ronc?=
 =?iso-8859-1?Q?dMRXnCwUBHhCrzoOZtCIAwQWXgGOlCpk8PuyhfH44RnBMdSLayoNSx584d?=
 =?iso-8859-1?Q?MRVXSVTwB0VMU0HhlfaQCkCnIiVckgXFqGEj/xGBr+0iwSRNS0I1qKrNok?=
 =?iso-8859-1?Q?xtvVqEZ2Tt3SWBluQMLw3pgc7WXyrXCdCO8hBXtWnD62e2TbJMkB7gQioD?=
 =?iso-8859-1?Q?qZZzsW9aLzjRS57ZRMX3Fj4RdgxhvZv4Wfj15UkledAAJC+PFFrunVBUHD?=
 =?iso-8859-1?Q?8hUBmPNDcPC7D+ku2u812ZVWW2DFpwqYtjlXPF8zKAe8P4OG8sbuMmBpdt?=
 =?iso-8859-1?Q?NgAe/2Nb8gUDBP+xwFFe3sD64PpE3SZV8/HZYfj2/lDb7mZladQXRC897s?=
 =?iso-8859-1?Q?aJdrgIW2xc0Xv9bLDxLCGyVkybqSBUAS7O9lc22fXxpdNqdpTnwXdqKWhY?=
 =?iso-8859-1?Q?yxKhPHPdJGf2PTPGCEzCmBcgfsTw0iIiMjIyhCT8a4XsmOXC0WGfnv6dnH?=
 =?iso-8859-1?Q?T0ZP+hfxuB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1691eb64-bee9-4c30-b723-08d9769d94c1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 10:02:23.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4rf4qqFhzxQn6+4TJk5FwLzRZWgdkdc8KWMQYae9WGwgrUUrDZ5qatRMcNJRC2/ism6f6a57zy7Yz4xFbburokt7E0MUOOXSM6ET7XYwUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2253
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130067
X-Proofpoint-GUID: 9GUrlZIvcCnCBhZHsmMrxzEHRBNJ7P1Z
X-Proofpoint-ORIG-GUID: 9GUrlZIvcCnCBhZHsmMrxzEHRBNJ7P1Z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:30:24AM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The 'channel' argument of hif_join() should never be NULL. hif_join()
> does not have the responsibility to recover bug of caller. A call to
> WARN() at the beginning of the function reminds this constraint to the
> developer.
> 
> In current code, if the argument channel is NULL, memory leaks. The new
> code just emit a warning and does not give the illusion that it is
> supported (and indeed a Oops will probably raise a few lines below).
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_tx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
> index 14b7e047916e..6ffbae32028b 100644
> --- a/drivers/staging/wfx/hif_tx.c
> +++ b/drivers/staging/wfx/hif_tx.c
> @@ -299,10 +299,9 @@ int hif_join(struct wfx_vif *wvif, const struct ieee80211_bss_conf *conf,
>  
>  	WARN_ON(!conf->beacon_int);
>  	WARN_ON(!conf->basic_rates);
> +	WARN_ON(!channel);

This fine.  I'm not trying to make people redo their patches especially
when you're doing a great job as a maintainer.

But generally these WARN_ON()s are pointless.  It's never going to
happen and if we try to handle all the thing which will not happen that's
an impossible task.  But specificically with NULL dereferences, the
WARN() will generate a stack trace and also the Oops will generate a
stack trace.  It's duplicative.

regards,
dan carpenter

