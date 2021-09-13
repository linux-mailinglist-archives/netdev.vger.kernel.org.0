Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423934088A3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 11:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhIMKAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:00:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55480 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238749AbhIMKAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:00:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18D6i0QM015103;
        Mon, 13 Sep 2021 09:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=5+PilYLT8B/mnuPdkDmk4mM0tK6RDUllyTrn6ZD2sow=;
 b=HsotXdBie9GxscKk6IfVqOi3kCH/n+rrWby8cR9Hh1XSqxoLFNA5T1eD9dq6blls+mFP
 L5k3pwunNyGgrJwbswWI6vYgQmoEdYSzYaOsdU0SUVyM5ss/39C6cLyHX+NXRmevOR+n
 sFWbU7WGE12L105nfb/q9UUA+X+ucMoNI9UlF2o4bhYbUiwqEuD8NckEqPwJREz3e1KF
 4KqF2kUK0gPkYdyvIPgkgXb15kyZfY1NsAL2kjsoQJVfv3GSaPqG831dax22GLOdWu02
 Mg4D23Wyl2sqRZSUY83YbtBz/MV3jD0Q4qIJda1IEPD3Hl7Y/XldNLgDXp1QdLSNmuKM YA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=5+PilYLT8B/mnuPdkDmk4mM0tK6RDUllyTrn6ZD2sow=;
 b=kMP8noES2vt3wDUoXyGrKFfUC88hWfD56/Mtx28u4cf73xpDtsaR4fSdbZuIEhoBapU2
 zx5JyZdxn88+rSFeFWbzh+msx0UXPDFPTA+j02VlPGfIPZ8v8ZPdHtJYk9PM3yPbEc/t
 GDWaNh5r2nlZ6KQNmh1OSDz/FvQtKyX29itKoPQEMAsFW9/4ZmPUK3frRt9X1P0OFZWf
 VP//Www/o6+3pPyHS5hyxtcIFq+Bhx7JQLsBnIaiHqMNZ+AcSs+v/5AcD37z6BLwSpsI
 aqP43UdIA7Odsi6Lc4oR2LHejoNaPbmaPaQSOPk8FYCWjFLkv9a/93eEAvq8QL/HUKCX KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1s9ymt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 09:58:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18D9t6ZZ005640;
        Mon, 13 Sep 2021 09:58:52 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3030.oracle.com with ESMTP id 3b0hjt8q72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 09:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RceyLL5XpMMTuTLJMps2mNqSb66r9u8aYgAN/J8nzHRzoIk8tqW8nNABGmLySrph6ien6yJuFcXSkbFe7rFBUlmk1ITyvkCPhF2oY+dB4o6NjjHr+1XhzokLcTF2pYFhH2+jaxkTFwznjtKcBJYFh1oq9KEdjEzwp8c17wCYCwSO30tJOQs4VzUCBjwwK2iF8x8qx5Ig2ZTx+/+ywwSjnxGfHqrKSQPRWLeyk/Q3Qzt731p66TCogLePcqIOs4sVbe3cIkW6FYB2EQiW0bG6Hj2/0mbNbndzcVfGVWa+ucWGG4bnAG4AaEYbtfwNmRBQz9tTlLPMI9BXjgnt1vNBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5+PilYLT8B/mnuPdkDmk4mM0tK6RDUllyTrn6ZD2sow=;
 b=i6If2X2uhucbACUG2+g5BfGJM3NnI11CwlcSK0oftk2/f2CsVGVabv9T/v7VBDcs+Bki6ocmqNgSqlTP1etznKWX5jq+eNLIJJgBd8PbPkrM9QUoplrDFHReVprzrpZhzIalM2bf7OWseAv4kW4+6HDwhcbjdfmkVD+1L3Iuoa6sMsn/UTd0EC1gnGDJea7/SMAq4MFhF/jfCoA+ZS4Q3JW7rckzcTntjNINnHyYQyQYUWMYAZ1d/PFOTftdTYhp7YKMhJXDO1WnAHEBO3o0Ela6gcaUgTJ1eycnCO4wIJ8mgQVGGSc3Ss3grmLCFHEZ75H0U5Gs7hWpPnmSRiauhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+PilYLT8B/mnuPdkDmk4mM0tK6RDUllyTrn6ZD2sow=;
 b=LeZznr/Ut6WMH/TEsW7q2tDvdP9AyrIb5rwU5Htvgvn7UsH33AGPiOXuVcfxdAxH2KhEyDuiuiq2cjF+oWEuFTCL6mdU02CpDn16OZ5iPykpDxxidKyBpZAmbY9svGU+uOCSiPeYS/YZ9Ed7iJ3i74zn/q3CzI29BteJk5FlvJ4=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2253.namprd10.prod.outlook.com
 (2603:10b6:301:30::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 09:58:51 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 09:58:50 +0000
Date:   Mon, 13 Sep 2021 12:58:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 11/33] staging: wfx: relax the PDS existence constraint
Message-ID: <20210913095833.GH7203@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
 <20210913083045.1881321-12-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913083045.1881321-12-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::19)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JN2P275CA0031.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 09:58:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8606247-55c0-4138-daeb-08d9769d165a
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22538134256E89DF7F33889D8ED99@MWHPR1001MB2253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:316;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ekSw90Y/pguEGy0Y3NDYABj/9zBQDLgWND4QCuYE9UPH1iu9sPQtQ5vk8p70kMumZauupeglOQBOLmNBQ1bhOeynNgXUoyhAqBY3ke6xpCSlD9J+esx8qyj4SKteBmSM3yYw+WpnMthUGa1K5hFynv7SOQ8ReyNoHorL0rEMrtTuYGRisFXxJeggHKMETZ2VIJoBDVk8KPsBCHLPGhwCjB6ARXS8FQ4sP11mYNxjX3eluAqCbY0jrlDGgBttA5OkbB/lPNAdS/48zScJlX04wXRtpMj/5S0xDVf7C8yaSG36pjdbsbfV2Nt1P8V/c0HTgla4b69H/wRReGoWXlaKwFZCXGfKgVxww4p56dDhOnRWQvi/qwYEm1s1BoPaLC2rt+7pYfeyhaOm4vFt7VuVEiOcTaDjy+sF4g8sDkC/Y95OqrcMbZWbi5vHW+G66H6E0Qn5TUKohYxMMBYnqgStYfxLBtsU9EKU9BK6oWdLfalCiSYrHDKKLVf8+20N236UuI2GKn7q8jnjxAEIH++HBdid99pPswhpEuGujXiI2WCpIuuvwtDHWq4hE6RBMUTPLErKCnB12tQkyDxcpI7FSPsPosNeM9nRAi/pp4NkdT8U/FSgmhMLs13+IcKofuSQRQF0M97ioF4w+5daVt2TMsHPOwWGaH/qfvaZNbNt1OyyWXXXl+8rC9t3J4viK5QfgqDyFHddRsHWVkh6Nuo6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(8936002)(9576002)(38350700002)(2906002)(6666004)(316002)(478600001)(4326008)(956004)(38100700002)(1076003)(4744005)(6916009)(8676002)(54906003)(6496006)(5660300002)(55016002)(52116002)(33716001)(86362001)(33656002)(44832011)(26005)(66556008)(66946007)(66476007)(9686003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qJw2UShIr+oCWuFkRPk+aWdKmS00m8JH7pylWTL9MZt4oYlq/UuzDyL+SK/N?=
 =?us-ascii?Q?52HasYD3EK+hN6CHgk8IB2zo4SGE69j7omR0GH3m8Fu517X0L225T5/yInho?=
 =?us-ascii?Q?z2Yvfr3qsumb8Vab3lXMH3+FRHgBcph7unhhTyfisWK3HNs0TH9zRRNaUGHz?=
 =?us-ascii?Q?TQ4eesVTfdlcmSJYHBi7r+7JDGbIYfNgQvJhMM/3kZevfhgWywwXkxIbSsXh?=
 =?us-ascii?Q?40mDBZnqUXVCR5W4IRuITZOahXQqI32Difj0DVhnAmivnkS5KbGBusNM5NWZ?=
 =?us-ascii?Q?KdsCtXgF/esE7wv/FBT8LCrD62iG//sYbFwi5ui3K/WZMkKP/8A5k4HuavsD?=
 =?us-ascii?Q?UUol0LHP4i9NQKXeFduOPdvxw5Tc0INV1YDcoOnv0AjF7Th0t3yMo9E4us+Y?=
 =?us-ascii?Q?NVpT0WWpIQirXv7tc4Um64jDPh2QMf4gIPrKckTz1hGVgs1ETCgoFNVFyWZf?=
 =?us-ascii?Q?yNuv2Ks9HWAXV/kSZY+nuBJ7/EHdzJ7BECHb0XJhblwPm3CqfOGgMDSetH1F?=
 =?us-ascii?Q?oCE9BdK2GaIL4/EKv7FrYGjH16ewcS8J1hWHVNVI29VZQV7pG3ji2MKfN0Sq?=
 =?us-ascii?Q?oXC/MqTxwUuEpy+FLaF7V6CIwtJ2ZnfzaIJDFJyrfD3116bJLHT6jAbuVDHM?=
 =?us-ascii?Q?vQAT1mqNaIQ17a2QKlg0b4Q1Y4zP88A2Cwx1y4oEv2IJB3eisqW0CoUn67D5?=
 =?us-ascii?Q?94uqBe3LEfPVQtK+y+S/aamytVSIuiezwhL2Q6uXhb7ibA+k650TbTgFhv8K?=
 =?us-ascii?Q?egqZ9NhA7jGxSIC1U2WQ8mpEMSIDxBt1eiOAMYYdHRw+Yv5E/0ovPZ8muG3H?=
 =?us-ascii?Q?fEE6PCZfP4F7kRxJS8BN/gVgrFy/OlAiABQyVhi65L1h1T3BwOluWkAZSc/K?=
 =?us-ascii?Q?jahkodT+rMPJ6SgunEBeU0q/QQdMV2jyBqQl7i0iq7PAKhpO4V27kIzRlPmH?=
 =?us-ascii?Q?NiRH/P9toCxJualZmkJlgMYObSUte4OZLX4B8WNbEPgJOaysXQxlBhJo897G?=
 =?us-ascii?Q?JCYH+Mr04PIr3gc3yTeZZwZpaMXM+oL/8gu52xHOBourc1L8NU256V7hl6tf?=
 =?us-ascii?Q?onjzrE8GC8uGZnVLQzB5yAFc3Xbwf9i/cefwxjCJ1++wggo3TkXsG0KdaVjb?=
 =?us-ascii?Q?J+ptwq9ZwFisAjdZxQ30afgjx8rUi4cgelgTgIevT/BP9k9C3uHXrXX/zV/f?=
 =?us-ascii?Q?ng08C23pLIovuO1vcO7jTlhkIjD03SESDuruuUaTjNYllil5iW/h34CtNRRb?=
 =?us-ascii?Q?ERbEber2DxHWgTxyYxL9NllqeKkXD22VW/yG5X8yWcsIZEXHB7V48CyX54CY?=
 =?us-ascii?Q?Am6RGIvJXtqXF9erK6S4ky/a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8606247-55c0-4138-daeb-08d9769d165a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 09:58:50.8650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dW4JWa1aaayKuc+BdzEX4FOBQ3PJTPkdP2vdmiJ9EiIlRI9hwazSZFgtLTrQkPnIndc0IOIQT1qb5WO0JKEuxgPuWMpN4rSAgv28/uzCZz8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2253
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=685 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130066
X-Proofpoint-ORIG-GUID: XOr9fEpnkcPPi19cWGgkXdJ6E0jpaOlH
X-Proofpoint-GUID: XOr9fEpnkcPPi19cWGgkXdJ6E0jpaOlH
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 10:30:23AM +0200, Jerome Pouiller wrote:
> @@ -395,9 +395,7 @@ int wfx_probe(struct wfx_dev *wdev)
>  
>  	dev_dbg(wdev->dev, "sending configuration file %s\n",
>  		wdev->pdata.file_pds);
> -	err = wfx_send_pdata_pds(wdev);
> -	if (err < 0)
> -		goto err0;
> +	wfx_send_pdata_pds(wdev);

You revert this change in patch 33 so let's drop this and 33 both.

regards,
dan carpenter

