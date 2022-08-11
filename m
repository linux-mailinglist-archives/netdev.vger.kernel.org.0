Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DA958FC8E
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235196AbiHKMlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbiHKMlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:41:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A473ED45;
        Thu, 11 Aug 2022 05:41:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BCSwK7013974;
        Thu, 11 Aug 2022 12:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=7piCo0ih0EJDCS0TDbMy2kC+FWwKLGB2B1j75tZdEV8=;
 b=ucamwd2ZRYOmcN/qTNpnA/ot7zbuEg3FgoQOq9YYa7SiZGj+LejyUMNagQ/2lPyB7+Ri
 d7mlW5Ai+1DQ6/A6eyThAFLV5iSyPhnrqUMX9LhQc12z9eM/QPlofyCS0B7O1gH/MlMZ
 90YTL9v9ucbFTPLw/JZQ3YodwBu6p9TWNJS3OteSSwYUOISuujTxxkvs9D3Tmf4j8eIS
 DWaXEIj7N/sBU2HNNCZPNRE8qYn8MhZTigbOy5OXzdP8HLaQoKyBBu8osixRO0DhRP9Z
 A+1c11gyIOrd3uKJNSo1I73otgBrl8DjetTlB7g6ZWHZs7RnNVzBk6SUmTlRhDDGhI7r ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwq9mg9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 12:40:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27B9HaqE020397;
        Thu, 11 Aug 2022 12:40:47 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjkbax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 12:40:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IuxglkMk5sL53tdlC9X2y+JJ6V3YrxQ2h66PVusBPS+WmMVHjSCYcnMQivclawYRn/biOAi8647orTW650bUwge1bk1lbIEFmd1CxUfogVkmIfNHw3A7s+C/YF05/ycMn8/xsviUdQR2ByOFByuejreTbkzyAVUolEbnboDHuaD7YViA89PdLG6+JmePxwQSL6oE3jSRInmlCDYEdNtUbWV3Uz3fzK8eMfKdbfJWetRfU9SDkK9qV43TsnT4CC4Y8fHFJ90+pv1g76OI1ai5e4pNIJVaqcNynsMuu5/PCDj12hlvPEEn1dFLd1J7DfC38v4rAfQD6D7QOmHTpWYwSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lwKNQ96yd/gDwGlqzm9oIkp3ULhBpvP1mA5HfEop8NA=;
 b=bsJXOIDxXUaJd02YPrsfLn8yYOW6g1knDBTlAh31gwTHLiI4CGHXOg2CtRfxsSrstWT5KIRV7QeIBFnzoco+rFMSrtrVd48yESNbYf+SUlaAHkXHceCrmaXAgSZQwYfDoq/8VU+L7BGhh3gJYyJoqFV3jyTyta4GSk/Wx915RZe0eYNjkUhjyRtAz9/vVWYkLHKNBSChCAZzFQqCuFzRMeso4ZBos1/aiDIdSFlOZnzHucd0hoaZpnC0ln9kEyXoTvoEcWa+qpNlBVXUldjGxP3aVbGYA8xGM9iylqKp3ML6lJBpS6NofOeSr/y6bO1lUPDXTNUrTO2A903xzEVPEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lwKNQ96yd/gDwGlqzm9oIkp3ULhBpvP1mA5HfEop8NA=;
 b=PeP3pFJyan8tpWNU+JXNJN9y8186IFiWGCoeIgWAnFoF4krcdCTf47lkZnlGFYTNN0Fw3iHCXQNB0msKIOh1fqchu4fjP/bADK5LapLaux9B+mi/jjgYQq+tHWp+I/Vepeaw4a6NN8NGPdGx8N1l+eazyTrB+MHKNaMYK3YoyJg=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BY5PR10MB3905.namprd10.prod.outlook.com
 (2603:10b6:a03:1fa::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 11 Aug
 2022 12:40:44 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.024; Thu, 11 Aug 2022
 12:40:44 +0000
Date:   Thu, 11 Aug 2022 15:40:21 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dinang@xilinx.com, martinpo@xilinx.com,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        Piotr.Uminski@intel.com, gautam.dawar@amd.com,
        ecree.xilinx@gmail.com, martinh@xilinx.com,
        Stefano Garzarella <sgarzare@redhat.com>, pabloc@xilinx.com,
        habetsm.xilinx@gmail.com, lvivier@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, tanuj.kamde@amd.com,
        Longpeng <longpeng2@huawei.com>, lulu@redhat.com,
        hanand@xilinx.com, Parav Pandit <parav@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Eli Cohen <elic@nvidia.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7 1/4] vdpa: Add suspend operation
Message-ID: <20220811124021.GW3460@kadam>
References: <20220810171512.2343333-1-eperezma@redhat.com>
 <20220810171512.2343333-2-eperezma@redhat.com>
 <20220811042717-mutt-send-email-mst@kernel.org>
 <20220811101507.GU3460@kadam>
 <20220811072125-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220811072125-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR1P264CA0099.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::22) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc6db887-389d-415c-786b-08da7b96b526
X-MS-TrafficTypeDiagnostic: BY5PR10MB3905:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tv2szcjCC9qmvcdUxfCI1K6YY3UytXZ+AsE/FiKDE8C24NkpvHckEvXCycwpmQ750mtGfBeEMU7h2rJMU9UZqzmTUDAubosrCR5CeWy0vtmpLbAnbDzW8N7kTNKBkr+LCpsZ6tywP/mLTq1nKn79yYxmm5SY3hMAXZp9rk0Q7wkYaZRNu5nmJmfre4KApbkiVT5WtNTnhUC5vR3Vq+LRg+5L92J7Bx4X2HZOvqnZHUp1HPWl2w1tHBGn5j0SpW6NyjAw8UvVUKW++DHJfREPZrSrzXRxlhsR7tEjlPRRFI4PCLFtEgHgMeOFLp8JUm+5gQaODmgqQFtf6pGZde4QCYNicnQxpi3vJSvNTQnC+GephOy7A1yH8qs1EL0rFQXgFuRTIinGVWgfY+lgFsFEud3oOqlwihbTpeXyNg5syIStvtkjo/GfDrAEC5aNz3gTRKZsbDvUQ2mkPY/JF8WDhirE6kJDDWBvPMOK5g2KVUvWIrZPefdkSFwLd2CZO61fJ/qUugsXTokcXqRmVM8BjsyVfRhn87ssl6Us8L4xEX4wNnaRWc/N7mLe5jgaocQPUifc7WsTB2TYdkRMxH4nIf53KjMjyQMIPo+dxc5D5xQkMorOt0rC0X9zqPMaC7E0VlqBaDKtYqZutHmIKemE9ONQgJhqIOuO7E/rU40HFi3zonieoX7HlGvDNbXT45RA6Y+D9bnvT5a98Q80VUItdmYAXgAcxqiut6am6RpCl7KIgUm6jz8il+VhVrqzQjwCUvnD0Vi518GAHXM/vcKWrHb6F6lQBWW2JXDk28iE+pfha9xfisz6u2tdc8tdlmZz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(39860400002)(346002)(396003)(376002)(136003)(366004)(5660300002)(6916009)(54906003)(26005)(66476007)(8676002)(41300700001)(7416002)(1076003)(52116002)(478600001)(86362001)(33656002)(33716001)(8936002)(66556008)(9686003)(6512007)(66946007)(316002)(4326008)(6666004)(6506007)(44832011)(38350700002)(38100700002)(2906002)(186003)(6486002)(15650500001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?pyw49/B1gUHwowZNleKxyn67ShCLbCd7MUn3ZNHGU9nErJNEcOLsRXOun0?=
 =?iso-8859-1?Q?JHQrFewZcIz2ZztKO9B2jOmS3ubRMPCOufbT0U2fOPWfn3btEMEa/z2ovc?=
 =?iso-8859-1?Q?kvpOJwpoUNKCGLLPnBJIsmy3mSRhwMPd5nTYIGDLbuMe4lT7C7XhsfetbW?=
 =?iso-8859-1?Q?BY3Nh9ZsUjI44GrfvtjGzGm7+iQIQbpCkPziqcFKQ6Y8NAvYhJcoIdcsCG?=
 =?iso-8859-1?Q?G4czl1dPR2i7nhq7FOr3qwDCTN8bQPwL7vV+YjLhKbyVrdNMPSDGwqihbc?=
 =?iso-8859-1?Q?94jTlExuXxV1JVMIE+xuZwyjZiBPZ5wEKtuHIdeerufkpIqnfrqIPs3peU?=
 =?iso-8859-1?Q?BLXQaxF4JH7WJIEHdd89qs2Lk3/qyxTSsuPQ/j17V/ljLCjwO/H2qAbLiq?=
 =?iso-8859-1?Q?gwdiPCYwRBoGGBcIIapEccvm5wrGef2qifvdnx5vQ3xknK9ia/egxbNa3A?=
 =?iso-8859-1?Q?cYwytKSABpfkULaBLXY22WIwPh41WpQDv//R5+/W9EQ/WjV5m7Lnh7ICgP?=
 =?iso-8859-1?Q?yHKTg0wenlSyI9lwP5iTZoGldxzPMH6wKQSeL12vOVJ8imWuDXadfAj2Ai?=
 =?iso-8859-1?Q?QZ4bfcK4ihWGev01oOnxvJH7dtukJxkR0nKUfpbtjgE1D90YftyRxcc2bQ?=
 =?iso-8859-1?Q?x3FG4Y84GTN1apk/GsKSqXy3cvZq45lCiV60dbFGVzSli0owrwxehU+UQs?=
 =?iso-8859-1?Q?hwbRBzQHhYLD4oW4XJqbE2FJQ85i18DIMFbeQAxvrrTVG2aolmbuBipYIU?=
 =?iso-8859-1?Q?Xh6UwbBnq4coaqh/xT1mVTfqSQ9AB2yo2MIiKiul2vgtS6OsmvFrxGow//?=
 =?iso-8859-1?Q?fgAPjKdyG5veMKEJ56R2NGHKhMGWteYGxz/zJ3mdxSQ+U3QpKNL6wzQ6q/?=
 =?iso-8859-1?Q?MzF7JAj+ypSwogQxlSfParxd8mtNJeQDrC4pvZbl10LeOYZcn+1+ENbTzR?=
 =?iso-8859-1?Q?McAbpetOCSRODdPONBVCeXPdtt+1TZ6GAcPRXpnwRXFT5BU0wtE7+P0iYN?=
 =?iso-8859-1?Q?yiCDJeN+lvsbOlxtWpkyjaxtt/bfJ4Y0e1v9Qp6xOGjfpKVFxxMIvA62IO?=
 =?iso-8859-1?Q?4ehMLr5iztdq3VMuiZKOREkxuKfmfAGaeC4MCsA9omte9HNSlKwC/KEJZv?=
 =?iso-8859-1?Q?W7KcxF6K3oFx5QXr0iaS67r4AF1V5k9t2X5e0K8OTqR6OZBPAGs5Tck9LX?=
 =?iso-8859-1?Q?Se6T59mx7thQ6xfFYbts4o/IndAT5/UL/EfDtcz/LOi6ytHYVdpdoFYUvG?=
 =?iso-8859-1?Q?dl/jcDNopadsLjOXIb5lCTrqimT+zTcgS4k8mlonBwc2M1YfCwRt6pF3/3?=
 =?iso-8859-1?Q?ZjTofbN1WyVT89eoUGLzfDcQTG3VqfZOgcEbqMM+0JAgJD9LHwifVxWZ2z?=
 =?iso-8859-1?Q?1KVeysFmfiyKS9FQBIfsvKk4OfWujj2baUOBZoXsN9hw24iWV/v2UoJCPS?=
 =?iso-8859-1?Q?4lKOPwplwkJsVSyK5rrPB0XAMFLlYkmBZ6Q+ysTaEVKItRoU3PbMcnHVy1?=
 =?iso-8859-1?Q?9/Guu0Zg1A+1W/e2DkhnTofyBqAo8RTAayR1Mr7uw7h1GqUUXSG6DPpVJL?=
 =?iso-8859-1?Q?yAAPlxBdexFR3e77VwDvK6oOO97b6K85IutKJJLB6/1wNepb+WrlU+iixN?=
 =?iso-8859-1?Q?pUEQ+M7xpHzunkHFb0/BDOnIKiSX/7ilmcJaNoE4GJW8dOtTvcvZKnFg?=
 =?iso-8859-1?Q?=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc6db887-389d-415c-786b-08da7b96b526
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2022 12:40:44.2417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6pmQ3IhFmFDOsep7YFVEePgWPULDiVmuMJwQ82WPd5Kp9ZoPONoKzr2PN5K732Nn41c85eM3xjVZcWOpGGDlnbB0FvDd0ZalQizDBLbKtRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3905
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_10,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110040
X-Proofpoint-ORIG-GUID: fKVQw_IMrloLF-YAuJmS15iIF1WEPk0i
X-Proofpoint-GUID: fKVQw_IMrloLF-YAuJmS15iIF1WEPk0i
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 07:23:44AM -0400, Michael S. Tsirkin wrote:
> On Thu, Aug 11, 2022 at 01:15:08PM +0300, Dan Carpenter wrote:
> > On Thu, Aug 11, 2022 at 04:27:32AM -0400, Michael S. Tsirkin wrote:
> > > On Wed, Aug 10, 2022 at 07:15:09PM +0200, Eugenio Pérez wrote:
> > > > This operation is optional: It it's not implemented, backend feature bit
> > > > will not be exposed.
> > > > 
> > > > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
> > > > Message-Id: <20220623160738.632852-2-eperezma@redhat.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > What is this message id doing here?
> > > 
> > 
> > I like the Message-Id tag.  It means you can `b4 mbox <mesg-id>` and get
> > the thread.
> 
> Yes it makes sense in git. But I don't see what it does in this patch
> posted to the list.

Ah.  Okay.  I misunderstood.

> It seems to refer to the previous version of the
> patch here. Which is ok I guess but better called out e.g.
> 
> Previous-version: <20220623160738.632852-2-eperezma@redhat.com>
> 

Let's not go over board with storing previous threads.  That seems like
a headache...

regards,
dan carpenter

