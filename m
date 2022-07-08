Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1D756B67A
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 12:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237849AbiGHKE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 06:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237576AbiGHKEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 06:04:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CC421E01;
        Fri,  8 Jul 2022 03:04:51 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2689TC68005072;
        Fri, 8 Jul 2022 10:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=5pLPxSfVxyKstenSeJF5S36kf0san/dvZM+lTJUj5kk=;
 b=PA50aJSWEClK7uNepTEBZoL1lirjNs/B6KGo9hv+IgJJBjI6PrnU57gxCy/+qz2/vyQj
 oL0aTg5oA3vyQMa5i4vjthnyKQ6BWTpbc8hSzC0vhsKNARztRAH/NSsh9dW8f41s1/so
 h5x4py0i5Nyy4To7vgnyw4i4pepyPuSuElcTKvhwEliSRnJF5BIoM6faxeMhcKGZ71tu
 g6CK9oLrA1c0tCFliM/drLZbAOaKa4nWye+NvPyHRWT2dOAH5yfsktPPdZbnkumXqDVe
 vFnJqDCdS5VkE4w/NgvMoS8PEsTTgT8axv27cKNHj4hM8Pf0gEOvc6MehQ4ndh5dhJ+k bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubyqr0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 10:03:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 268A1thI017973;
        Fri, 8 Jul 2022 10:03:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud9qcwg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jul 2022 10:03:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TuiT5fxH64XD++PmsUHkgC7ckixWshUllFXzVoKD339c0SUUkEprR7RnhpyFoyYisCA3NgjigZj0XW0EB5megweHyiCr6hSkfjB4vmdtFZJIMeIcOup727hO99v4rU+KHGM2VxwCN0yEPdAuLSBVLjtDTX+2+alSVMxVUN1rOEFRoTOqCwuurnCJXuJ1xPpJDNTQHwg2CNYTSw5W3ZOLPO8s1GctuCHa9QH/Ddp/uuq+iey3U7OeI5ijPny7xK4dwWsD56h4gO5WjB52nrwuK9WvUAqgGj2AkqywRBgcs4ouzPFjlOii0aq44XhdilOpDJ5HsYjXYD41Haw5vgod9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pLPxSfVxyKstenSeJF5S36kf0san/dvZM+lTJUj5kk=;
 b=kn1SRlyC5i2qMq14iJp3u48Sc+6YLSyptZNqh+j52LiRAD4GE2LcttsO6tAENFsPKuzk0Ce08wCzR+lQG8YmiaOgDnuauDBR2FvBbWexvMMmaZ1Gtgall4dYhQ8nFYVBMV+c4a2xbe0iKblpnv5Lbi5/H/pOGmdYGjmGP1p+wxaosjR71LV5GqWcVa04uuscYArmjbbs+qiZZIVeTb6tTvgvlzG5R23qxAzaJ8iflf+0CtE45WIcD0krL0IkSbT/GPMV9C2DEQxNKh8rwrnxfyMJIVACZCMqqIyLV0YCRqAjFA2nxRbNB1uuBMsc2b+mBbGgrzbk6dvqLMZZkRVkOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pLPxSfVxyKstenSeJF5S36kf0san/dvZM+lTJUj5kk=;
 b=d5aihqu/jeH907HQhVDkAIsIAk1o2UUnZLfhRzqbZs24b2LPJu/0i/iO9RegZ/usVjNRK7F6zKl0TV7RkbNtwNk5jSLgf7v7g1ni6mo16f9Ema6DtSWAvvMnjH5lMjvtoIAn4Dcxo3jB26XbdYBYv/P0T7VJlIaKMBVEZ26Hd3s=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4924.namprd10.prod.outlook.com
 (2603:10b6:610:ca::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Fri, 8 Jul
 2022 10:03:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 10:03:37 +0000
Date:   Fri, 8 Jul 2022 13:02:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtualization@lists.linux-foundation.org,
        usbb2k-api-dev@nongnu.org, tipc-discussion@lists.sourceforge.net,
        target-devel@vger.kernel.org, sound-open-firmware@alsa-project.org,
        samba-technical@lists.samba.org, rds-devel@oss.oracle.com,
        patches@opensource.cirrus.com, osmocom-net-gprs@lists.osmocom.org,
        openipmi-developer@lists.sourceforge.net, nvdimm@lists.linux.dev,
        ntb@lists.linux.dev, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        megaraidlinux.pdl@broadcom.com, linuxppc-dev@lists.ozlabs.org,
        linux1394-devel@lists.sourceforge.net, linux-x25@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-unionfs@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-perf-users@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parport@lists.infradead.org,
        linux-parisc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-nfc@lists.01.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-mediatek@lists.infradead.org, linux-media@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-input@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        legousb-devel@lists.sourceforge.net, kvm@vger.kernel.org,
        keyrings@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        intel-wired-lan@lists.osuosl.org, greybus-dev@lists.linaro.org,
        dri-devel@lists.freedesktop.org, dm-devel@redhat.com,
        devicetree@vger.kernel.org, dev@openvswitch.org,
        dccp@vger.kernel.org, damon@lists.linux.dev,
        coreteam@netfilter.org, cgroups@vger.kernel.org,
        ceph-devel@vger.kernel.org, ath11k@lists.infradead.org,
        apparmor@lists.ubuntu.com, amd-gfx@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        accessrunner-general@lists.sourceforge.net
Subject: Re: [linux-next:master] BUILD REGRESSION
 088b9c375534d905a4d337c78db3b3bfbb52c4a0
Message-ID: <20220708100219.GJ2338@kadam>
References: <62c683a2.g1VSVt6BrQC6ZzOz%lkp@intel.com>
 <YsaUgfPbOg7WuBuB@kroah.com>
 <20220707140258.GA3492673@roeck-us.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707140258.GA3492673@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0050.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::10)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60888dca-74ab-415d-c312-08da60c91fbd
X-MS-TrafficTypeDiagnostic: CH0PR10MB4924:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpeUnUA80G+bljAIjcJUjdGQmN5uY1eFjfrdzbA17ZIS3uabFZv6Hj1kGve2Lkd6ukSIrwiau9r0ovgbwx+dZEkKmEv6+vXYk4KZAt/MIhaL91UGE+paD/7pDhxzw4BYYVzzpcTlpWSU2EifziKfjy7zSFc7TnpneOwuqT8aeevBVsak78DiURzZSmtUYh/Qt36gA5/ksmagoLtxfOrwnwiX4glTSsn8t5yf7q4IzdByoZMhq0/OHP2LZ5gMTFtZ6UHjHdMMXGvblMy4nwFFyDxr86OS56TwXu8Un5G4D4DsBq8RB57WhWGKUtSyUbZZbVRFVkXmco1NenhtSk86OVpxyYHEtK55FxQsoFvpcV9t5yQLp1tE1ssb1OlZae0sqORl49xAPisMT7jN1cFGRywkbs4jxpVhNo8QYdWoQ3VACsB1KUJ93fDES9dLhmgaIFwDWA8dmP2LXuL1Pd+DFJJTLkU2NgkpHh5jR/cu2c2jTU6PpCMhJIrwzdDt8sfkR6UcBI76NJL0PW+PVyYni0a7Pe3rbeU1PW70RjKKv2/VmnwT8TE08KBGeDQFp1AHEmMbpH2SgzlQWxMvwgGWtM/6/xUqkCQd/CwrTTQo63A1MOH6B7syzqHOaHclI2HJeLiaHI3iu+zlJxnG2+klM626OprekeiAtpkpRWukWRhFT8PONEEVRTQsT2XM6vCyFIqckzuC+ioRgs4tOx6NIenPb/oTrABzGoY+mHsNaR1Q2HerdVNbOlkOvYEcJhoSs2/qCEmiEqL11HGPPZoOhtWl90u/pVoJWO8OqO1Cy/1JYLe4uJbmE6i1YFG6PeLI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(39860400002)(396003)(366004)(33716001)(33656002)(478600001)(41300700001)(44832011)(52116002)(6486002)(38100700002)(6506007)(316002)(54906003)(6666004)(4744005)(38350700002)(6916009)(2906002)(86362001)(66556008)(6512007)(66946007)(8676002)(7336002)(7366002)(7416002)(7406005)(26005)(9686003)(5660300002)(66476007)(186003)(4326008)(1076003)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uG7EisZU53uo3Eyn1rAkH1Zp7prdDVjLvtewrji3nHaInhwwPqKJd8IS9Ml6?=
 =?us-ascii?Q?cCMDRE9xZtRy2ixvN9HtQCxQ6wyVdCMjht4JEfcGvVBGnhiqaHo4dtqdZQNj?=
 =?us-ascii?Q?TGMY5D1FDrgRGu1ZqSXbxw6awVGysMa0+MX66gOjQV085NsMve2O4eyl5F5y?=
 =?us-ascii?Q?1R/1hXNMky/piEnyu/AV2u9cPc8QXEEh5K/YB5xHM0lnOA68c0zycKWASuhL?=
 =?us-ascii?Q?Kla+gf2FV2JSVMUu/Ri/D4jFuSeza/bxZHWLcnm2ZsVWcrf0/LgByhqRjtSp?=
 =?us-ascii?Q?is7aqVU5aytLlmIcj33/i5SfhSOL6wtmqbxmSOEOtAVcsEJtIXON2a0hsur6?=
 =?us-ascii?Q?hsWV1BvYk4AATAbHUOntCKDw5fmW1Zb7JOZVwY9IVuxyRJroXe+t96bJLXrI?=
 =?us-ascii?Q?MssjNzxXj4Jypus/6TmDDUIrYr/PohLpQ7G33Mmk20Wl8iVHL8gXU0umskty?=
 =?us-ascii?Q?O4Hi9SohVBBFpOOh6t4TgJ/w2hGioWQ3sldG+lmRcJwb3j0MzuvquWbIKe1R?=
 =?us-ascii?Q?gnxXwQFlT03ge3rnLtt4I5eXee2ZugYaT8hbKKltmH00UW2rot4ogdsXX2iI?=
 =?us-ascii?Q?DNsESB9w2oxovD/ZQf1hpR0G4CNtCUS0CYB5QKnSBDpXPeXkQpoHeFzSSfjR?=
 =?us-ascii?Q?wLuWIMCwND+t3ovztoAdWN/UQtE5mMC0kkUBUToTTjIvLciDMD0PSNB6BJUe?=
 =?us-ascii?Q?w0PR0q9LRd1D/jkiavRKpLKgXzeczspq+Psu7R01u1srIE/QHzUUjYVl5f9a?=
 =?us-ascii?Q?L02x85oqudSEWTubWsX6ss1WfTqA+8NqL5ENwQjoi9UEoTolcwA7e2XUcwAO?=
 =?us-ascii?Q?ic9ZTDSAl8/AsX+2l6+qsgzLGODxDFe3K1ko9b4kwkQxpr9NU9z8O/MWDlAK?=
 =?us-ascii?Q?Dnlvq31Zf740z3fuyX3wN9p5/ha59mVpxZF+xjtVxT7DoDfkostGyBOBfUce?=
 =?us-ascii?Q?e6fdpEx92+LmFi1lzmVO4Ia+ECDiem6tXYEmQXIyfxx3Lw0RUCChVAujKWLo?=
 =?us-ascii?Q?oUy4+s0iF6iSny0nF8zOLNHqJzxvFEexDubf1ILb/3btBYa9NgUS5BOaIoA9?=
 =?us-ascii?Q?WqJ1H2aDG9Kic8ymHAc4FFqNBtuTucRoBG6Ms8LMqLNF0Vza4OaikcRksmX4?=
 =?us-ascii?Q?rgBMlDqx5pO3KFCTenU+qbHOBovKp6H6HnXn/7m/aF3l+ZqmdwuG77shGwxJ?=
 =?us-ascii?Q?u+KGV063dyQ+dCgsyvudHwbxefjBFDbkHK/Ybw0NmKX2mYGuv7jbzKnp7JDc?=
 =?us-ascii?Q?AF5HmXDQhKXZbO2HxUKsXY8vRrxFZhmbIJJMirc8HFwPS3gAzjzb+szX+vF7?=
 =?us-ascii?Q?xOUKc56091EkjOl6fcqQEf5AMF6UjW4HOZCLHO1S/4o81dPO+oVZQykyHGNa?=
 =?us-ascii?Q?fevSECWId0k6CwanCU7579YdUXJJMBRkComEJNrTAoR4lhftqLiI0U3rDdrj?=
 =?us-ascii?Q?Del01xUlm7N66LbqNEPYOHt8Vj9P+Nd4ahXQKeqyeKRQ+d5V2/xM7j6eGiim?=
 =?us-ascii?Q?CELTFADnEsTdWjQiE8bsPhByqbhH87XWEemEF1ulwsM6DII28FAYU+uBiySC?=
 =?us-ascii?Q?89eQCwECLDAfd9gxbLFLH7xJjKAclbo03RJxaMbLiExaPJ39HgBBQBjVroGH?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60888dca-74ab-415d-c312-08da60c91fbd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2022 10:03:37.5131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xmfxxd2ImvCkN86fhSrHry1xr1wVpvkQCd/kvXC28R2/OhB8G8NrxAgoSiTGxSTnG4h/h/BFA9rqzl+lMJyKXtKr24bFre3OPhNr8wLciI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4924
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-08_08:2022-06-28,2022-07-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080036
X-Proofpoint-GUID: icb9VT_VTJOlnrB-CrUswsRECbryCeZq
X-Proofpoint-ORIG-GUID: icb9VT_VTJOlnrB-CrUswsRECbryCeZq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 07:02:58AM -0700, Guenter Roeck wrote:
> and the NULL
> dereferences in the binder driver are at the very least suspicious.

The NULL dereferences in binder are just nonsense Sparse annotations.
They don't affect runtime.

drivers/android/binder.c:1481:19-23: ERROR: from is NULL but dereferenced.
drivers/android/binder.c:2920:29-33: ERROR: target_thread is NULL but dereferenced.
drivers/android/binder.c:353:25-35: ERROR: node -> proc is NULL but dereferenced.
drivers/android/binder.c:4888:16-20: ERROR: t is NULL but dereferenced.

regards,
dan carpenter

