Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF31E408945
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 12:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbhIMKnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 06:43:50 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:64160 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238823AbhIMKnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 06:43:47 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DA3G14006265;
        Mon, 13 Sep 2021 10:42:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=/fQwCXQ3lyxYQZqKFTugV8YOUB1W8hLKTVFwrePrJBo=;
 b=rCTmYGTjC1x6zje/36kltbHmps3mROy2tba2K+tpQuzq8ugjcACTt5kQ3qrhTs2gApgy
 RhbGCHxuK7yRGEu/AhHIrsaeWuwCyJLZnPATt5XgOf9h5gcgV46UDq494MKzPRFGTcLp
 vh2fmipjKtOKSMDxtK1uC7DHAAyCTTfRDWBAcdQFo3d1f643LBjcQYXKRRBDKGR0/16P
 5TF3ZGoBBarD9Px59lkrudJBd4+xwce9uQ5oe/IcnMliFCRaml1zO1DM4VwyXbDA5UR5
 dy8mMnJYhtedY7ee65xn/0PAb9OIFsMxhPap28UWW3zfdCr3Yp6X4mKeceZQIG6qFMHx Xg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=/fQwCXQ3lyxYQZqKFTugV8YOUB1W8hLKTVFwrePrJBo=;
 b=jaraMYr63T7Ku45pzI2XgCXZPbDKt6gsEPbRM16+Ccy1IACgciMjNYE1P+94zWizYtVl
 mx/1ZVj5fkHWMaAfi/EFINz5JYh5Th3UAmLKxMtOMp/e5uu7De1zG1ZkYf/11g3y/0LP
 VamZ0WEgjmieBLOeTPKlGW7E/rhPyk1Km43ehONL/RcuJfTnpmO+RzTTbmMKxp9WL9Uk
 UiKVoK7UmM5LYku+NgBjaBdKDa4O7IdUqzrB5/bgrYetAKx+0e/4MMwiMQorREQXhNaJ
 qk43FQLuMWMsuV+izU2UD+ddhg/RMP90EZkHfGLDrhenhHPVz+awKOhaAJ0yaZ/5aSUD cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k8sa2a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:42:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DAfKqK030767;
        Mon, 13 Sep 2021 10:42:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3020.oracle.com with ESMTP id 3b167q8mm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 10:42:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=myddR27XZ7b/DSoDzFHwB1OOdUQkyBJzugKll0GDhwLytPrjSdHrbmr+BtK2/pHBtt1d0lVsFAt5J2JIlghX8R/sqbrKdnehYXO19dmxVE/yH29jiOnKSjYyRzDVOUlcFthETlL9YnMyvKcdLyLTWv8Cuk/mve7LsoI33jxjvka1SJqD6Sd7x2v+9W08+tqRN+stVdodGoneQscUup93FrR8l3lp2COIe4DYsv7JUZpKTDKeSJRt78bg6T9ME5qVWxnIZfYm+N87G8oJB/6nvbTm7gtXPdNzRLuSBS4t5cVwcgMhPWOVgEoEPfCPPqPKVh034X3z2OdH9F3EY+B/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/6njDP2lymzEIkwArmwJIgn1/JqXule0fVdh8sTZ3b0=;
 b=UCGmN1bDkoyoyvR7bRlsgW+JEyqRXUzsZYuIhV3+kvIB+hqL6dyXkfTGi+TGc0nvu5VEbPLtx65Ig5EgQ0oTo8bXWz2XE1wgQjY7Fa93bvp9TtL3eyHiWjJk3PKoJsmOdPf+qLWXZ9yFNAEaG+0gDAKn+tmwd4J4sG9e/V7OQSos31gfz1OTBVh86ZPlhh+dVGSY70cq+DWDg7QYxRkpE8XNQvrJkGtvFIjN7DFs5gSRth30+87dBB1mb2kk1GCQT6KwBWp6/nPYTyL+JATmS1iXuXKzJoiSrHhOhPAhRiEGy4DZtnyYA0DBtsu0qFSncgY73l8ZPT0FuS6Z+skljg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6njDP2lymzEIkwArmwJIgn1/JqXule0fVdh8sTZ3b0=;
 b=qRcHpQeS+zj3JMRC/7kyFbaQ25SCnQDx8h/7aW8GEljAkQx8ePWDRS51Ap+xD0e+ncDpbECDB81Jme83ziA3efn4Cci5WuUmvgOfTfin7iLNttE/Vq9FObtX0VB3sstqnRvL6kEclgnFISi6pCnPmyvTxQmAaiMyoTdeOEHoy3k=
Authentication-Results: silabs.com; dkim=none (message not signed)
 header.d=none;silabs.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1358.namprd10.prod.outlook.com
 (2603:10b6:300:23::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 10:42:18 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 10:42:18 +0000
Date:   Mon, 13 Sep 2021 13:42:00 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH v2 03/33] staging: wfx: ignore PS when STA/AP share same
 channel
Message-ID: <20210913104200.GU1935@kadam>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
 <20210913083045.1881321-4-Jerome.Pouiller@silabs.com>
 <20210913093328.GG7203@kadam>
 <2757254.9bAbmTgjDO@pc-42>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2757254.9bAbmTgjDO@pc-42>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::21)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 10:42:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 003b31b3-5672-43ff-2e81-08d976a328b5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1358:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB13585485A2E6D62CD8AA9CCD8ED99@MWHPR10MB1358.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BLbmJRn9k6+4R2Y4NqSKRQhOa2dTXyzS8L6cA3MZUfkzr+eu/3gW/n2vBNkzw55TtR9iIFZJuBqwxWGp3NKkODYaFtr3+hlTGO6dozjRajO6OcIreGUvpMRZO4vMYg+wzf1dQ39uEGaZ8XW2TgPn/pQfx11+5ctCtvGunNjJEqQOj6dqYr5fP2suVXI9A2xKjPnKSRfjhBWcy/YJXqT3FSIIMoJ2MNtJ5JCRcR5wZzS6a/6WGsxIuiRdBilwgX3ciqsdtaio2x3jeQoM1+PkYsDRDMZ3fKRz27g20xRIia36GKh2Jtf2whkHTGQ8jRc5S+nNS4CDIDxKsAJdpEGszNYaxYz8sXpTV7GacKwHheRNfdgbl/dNiGrS2C5KyeOCqupg7CQmuJhfGTmktwU09VMe4ddtE34vOz9gOQAaqA2jnYzKMFt1/ydNid8yk4J86SXz4jMHFMpFj0X01cwS9MUIbDLz3TcvgXGRSL4VbjOqlUMXULgrfXRt5FPn1LgTL5e1LlB3GZBjf1WybvjLrlJDn4csQvprZnwtxksdYLAMHP3Te+cob9rgZPXszk0XikazWMKSd4KHeTObqrTCB8w4h4uZwbNnU4pSq4unUE1JHDNpcs22ChOBP+sNEVvF9VYlyQzLgafzFYT1vjFr1TOtpl0izaoD8Qu0MjKHsfDCnZ09n4NyM1qhhdppdvkY/6XmfDqiDR+NfRX/HesbMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(346002)(396003)(6666004)(316002)(5660300002)(1076003)(44832011)(33716001)(83380400001)(54906003)(8676002)(4326008)(956004)(55016002)(6496006)(9576002)(86362001)(186003)(478600001)(38100700002)(26005)(38350700002)(66476007)(66946007)(66556008)(33656002)(6916009)(8936002)(2906002)(52116002)(9686003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fa4uxoa1pAZe7gpl5CDr5TOLZwxnSmmI8DgP39yq9sv9d+3IymOkyIgBVu?=
 =?iso-8859-1?Q?53gr3gMueDIii5pc3Sxm92vOq38zAm+emMz5BhrCiM/VT13My05CgNltbz?=
 =?iso-8859-1?Q?zkGe1e2RRda1tae/7EQwGPziKomxR/33GxP388sI065PeV+8te8Ej26HHx?=
 =?iso-8859-1?Q?ScuyoqntxTb7HPXDhCj+hjO/XSGsERMfCXfNxNQzqLOpRtCKbPw/XD9H/d?=
 =?iso-8859-1?Q?eITJUcM/3bxbVs6RsuJ/2v1cAosQZBhIc/DH4WZxE0Hc9ipeQ+Q2rp2tDn?=
 =?iso-8859-1?Q?TmuVxiPkvRaDohyo4JZG9DsXlCnAI7n0KG9E0lsFqyPjSXuZ414J29OtHg?=
 =?iso-8859-1?Q?oNo+P6l93xaCtnIL904korw+6/F7r7q3HwKIXOBQhJ6rZ0nv3PwfO4muW9?=
 =?iso-8859-1?Q?1aYOC5qA2dLERJUdhYFqiWhddrtlGRjAzx5dMJNtKi3mJYZx08oOuW8qCb?=
 =?iso-8859-1?Q?QCvo+R+X58QGK8vO6GGkuNsFA1U0g987s7mQU5WWg9cwJKKKkU4BDoayyK?=
 =?iso-8859-1?Q?zUBaCSjMUcvDK0PufCXzCofr/HklM5r7kNjPhzGcoebPXjnyTpo9A6tS0h?=
 =?iso-8859-1?Q?tP7cOvU69Wn63auLOWnGcKM5/Q5l/phJ50vjPn3gRb/XswzyaC6UjecJ7A?=
 =?iso-8859-1?Q?TId6Q1437jUp5J+oEYhNr71XnTEQSTOXar9tnxoUeRhkNtIUXOUCtwqqHm?=
 =?iso-8859-1?Q?mRcDHCKXfXoRbqm84t7KMDVKQCFn6CmJti6wdwfOWALQH0lcxwevqZVvQ+?=
 =?iso-8859-1?Q?5FOLPetIWWWqxKY7YBrPbYNpfxu3l9FcSnXMZSk0KHbB826TYjCoTNV/6j?=
 =?iso-8859-1?Q?NDLzd48+0DN4hX1aTtxt4EkIsuLFtUaXNhuQiUvihb4XeVFyhjLHPZIAck?=
 =?iso-8859-1?Q?m08soqha5GPQ+GUvlPvmc3wYsJqzimKkTNsJKoCArwmpJGv2nCXHSqeUjy?=
 =?iso-8859-1?Q?85JEIU9pFv8YibdH5uVykNJOhQk6HN45McXERzntcM2yCjNshBdFnAPSbU?=
 =?iso-8859-1?Q?wcj4Tu4d+ptLJc49BHfTMz4i+Jf0zQupEA0fg5FQKFd+jswfEZ0vaNmr1s?=
 =?iso-8859-1?Q?CqU1Zhp8Oq6yD0XQKS6kHaIupf5KNqIqO2YSIrI6QaahwuPa+fiu86NELo?=
 =?iso-8859-1?Q?zmSahCnndYHVKqRJX3s7Secba3tCGGAbxnT/v5uvpIYLQ+gdpNQU3pmPUW?=
 =?iso-8859-1?Q?tMhWdcomn96gKg6rjKeEZJaMyBlP/BEjfgnacxwLn5PgU/vBLA5QU6TBRk?=
 =?iso-8859-1?Q?cwWMCmyPeIUVE3aRDo3S3ZQK/NVgO/77lpEQYFHuQeUW1fdDwqSPgJvhyn?=
 =?iso-8859-1?Q?/hgrivW2SmsE6Pk5qm2b4p1lBq2gKjN5Pd+/Qqf+sQczG08X9ojtauDr8d?=
 =?iso-8859-1?Q?eagdCewXYn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 003b31b3-5672-43ff-2e81-08d976a328b5
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 10:42:18.6414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v7T9LQZEQplVkpEKQKiYOVAjlNiB0IBnGKOglAXCVrga2KY4n1N9zqYhj6aFd3tkhtyP+Hvf6oENLsza/SzK92M32CloBf7SDmsdDkEo10U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1358
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109130071
X-Proofpoint-GUID: krk0GH_jlSxo9FG2U_fCiluXsGhgRYN6
X-Proofpoint-ORIG-GUID: krk0GH_jlSxo9FG2U_fCiluXsGhgRYN6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 12:36:25PM +0200, Jérôme Pouiller wrote:
> On Monday 13 September 2021 11:33:28 CEST Dan Carpenter wrote:
> > On Mon, Sep 13, 2021 at 10:30:15AM +0200, Jerome Pouiller wrote:
> > > diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> > > index 5de9ccf02285..aff0559653bf 100644
> > > --- a/drivers/staging/wfx/sta.c
> > > +++ b/drivers/staging/wfx/sta.c
> > > @@ -154,18 +154,26 @@ static int wfx_get_ps_timeout(struct wfx_vif *wvif, bool *enable_ps)
> > >               chan0 = wdev_to_wvif(wvif->wdev, 0)->vif->bss_conf.chandef.chan;
> > >       if (wdev_to_wvif(wvif->wdev, 1))
> > >               chan1 = wdev_to_wvif(wvif->wdev, 1)->vif->bss_conf.chandef.chan;
> > > -     if (chan0 && chan1 && chan0->hw_value != chan1->hw_value &&
> > > -         wvif->vif->type != NL80211_IFTYPE_AP) {
> > > -             // It is necessary to enable powersave if channels
> > > -             // are different.
> > > -             if (enable_ps)
> > > -                     *enable_ps = true;
> > > -             if (wvif->wdev->force_ps_timeout > -1)
> > > -                     return wvif->wdev->force_ps_timeout;
> > > -             else if (wfx_api_older_than(wvif->wdev, 3, 2))
> > > -                     return 0;
> > > -             else
> > > -                     return 30;
> > > +     if (chan0 && chan1 && wvif->vif->type != NL80211_IFTYPE_AP) {
> > > +             if (chan0->hw_value == chan1->hw_value) {
> > > +                     // It is useless to enable PS if channels are the same.
> > > +                     if (enable_ps)
> > > +                             *enable_ps = false;
> > > +                     if (wvif->vif->bss_conf.assoc && wvif->vif->bss_conf.ps)
> > > +                             dev_info(wvif->wdev->dev, "ignoring requested PS mode");
> > > +                     return -1;
> > 
> > I can't be happy about this -1 return or how it's handled in the caller.
> > There is already a -1 return so it's not really a new bug, though...
> 
> I see what you mean. However,  I remember it is easy to break things
> here and I don't want to change that in a rush. So, I would prefer to
> solve that in a further PR.

Yes.  That's fine.  The return -1 was already there.

regards,
dan carpenter

