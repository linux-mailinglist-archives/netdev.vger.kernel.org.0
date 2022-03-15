Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656244D9D4A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349136AbiCOOUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349151AbiCOOUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:20:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B71F54BEC;
        Tue, 15 Mar 2022 07:19:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FD59cO029158;
        Tue, 15 Mar 2022 14:19:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2021-07-09;
 bh=hq6ofKC/WmplhDPhfQFIp+LSpb8/m8ARTe1zr6I4hDg=;
 b=CMgCTVI/Zux1ednO8+XNhC1dUwsfTUGvx54/dtPmJNvlyDEIBvKr+GuF8MfiC5kjnpU7
 5cxjfIhAyXwmwrUVYDMNQpKYQyzMJ1kCjFPbNn3lEOQyEgsRB0RfOrSAa1gtkT+JMPR5
 OEimvH2uemG173vuyAcpAv8L8fvdtRtCQsuLX0fErbHIgWx949a61yI22itzjaTJLHuZ
 ZLmyKWRrgidZ+gOBsOGVhIg++juEZ153RoqwDRomR0ul/0zrzPcf0+dxbY+yinRA8wme
 gQ+peOIqjHmF6bDdaVe4GXYmVxqako2dYlHJX3ct1f5/CuhSzfgNLqiB8vtm9V2AfAfH cQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3et5xwk5tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:19:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22FEBFut110033;
        Tue, 15 Mar 2022 14:19:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3020.oracle.com with ESMTP id 3et657ra1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:19:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwUqhAag11m5OCGfzogunMg3EAh7bE2Nhk8THca23qXk+2YN8FwE0puW+KUq5AP++dI86OKgnBU3CgZh0JHXjDjVqMQPJpfiJgimwu3r/j3LP9dD05ymjvL0qxjwuaMyJJp5BNe8zKgdq9CrZwhBxe/a1BU1vgF417r+dpEgXrG1TZdfgBHG0zJ+XpQlft7dtQXYtKoal759tsTwwdzzZIuwKMlUWnpFJW7jPlzdB+otR7DBDlpnILAoTWRaeqkv3D+atdKbUtam8mKwiCqDG7BzFDcot/wFUfIEmiRG82TQAXOhYzSYckX13iY63VK4y7hf2BQXkTXa4rndeY8dxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hq6ofKC/WmplhDPhfQFIp+LSpb8/m8ARTe1zr6I4hDg=;
 b=EVD/3nWOgFeDZ9nDqCIcmRMcmsujF6tyC/lhlCMwBTORmz59/GlDJtPbEHWWuVD+UNcbGmaycPucShhsMOSQpy93H+pIEsb/wQRm5G0BWgatAj/Yha8qvrshbK90PR2sfzAHkCpTzWzDrVwXTipL4DXCSFL4xEK/874wLQluSdXH2HQPcW6mgjY1ORNfYvBDO9F6USMPDDShz4LyF/oMti7AMSbK2rLuC4w/FwbgCXzzJxQ34jrFYM5SIkLO60C6Rygv+G0AiNCylasq4ww+dma5Ef2Fz/Da8onm9IpSMtwDjoqluCRJX3NHMVyUPkbaTGq6Qnt5JJJ79ODQC4zWZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hq6ofKC/WmplhDPhfQFIp+LSpb8/m8ARTe1zr6I4hDg=;
 b=Kl3NcupZ8C++Iej/ETdfn+7X/YZkwWUD4YoYuZeCCkRvBcvpx4bz6kwPCiYl2oDFYvGNqiRpL8dUdjNDC3fuMglhlVbUVxmgPwlxKUCNOtdqyprm93RRhoBvKWe/jazM9Z2z68cExqZ+rsmNy/DqB1lsmsN3/QSELyty0XUXwI8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4198.namprd10.prod.outlook.com
 (2603:10b6:610:ab::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 14:19:20 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.5061.022; Tue, 15 Mar 2022
 14:19:20 +0000
Date:   Tue, 15 Mar 2022 17:19:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?utf-8?B?5ZGo5aSa5piO?= <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de, thomas@osterried.de
Subject: Re: Re: [PATCH net V4 1/2] ax25: Fix refcount leaks caused by
 ax25_cb_del()
Message-ID: <20220315141905.GB1841@kadam>
References: <20220315015403.79201-1-duoming@zju.edu.cn>
 <20220315102657.GX3315@kadam>
 <15e4111b.5339.17f8deb1f24.Coremail.duoming@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <15e4111b.5339.17f8deb1f24.Coremail.duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MR2P264CA0012.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::24) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b300389-b64e-4f01-bf99-08da068ecbd2
X-MS-TrafficTypeDiagnostic: CH2PR10MB4198:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB419815075112140E39F1AD4F8E109@CH2PR10MB4198.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+T9O9AcH1q/oPlldwt9xnxgOMmpkuPUrUp8djtQWOR6KBflSQQTaNsdRa7lt/KrD436e5GQfYNU9pSKs6P3MI553o5bSt95/XKrBTVSclVeJ7j76ygiQeFJKH7nrZQUUySQLxvf3AGqPPwF0wh7/OnIz8jhnhXWC2M6hdvZnJbPKiCEW9+WBBPVBzmvP2McGRASxCat42xwwE44T8YjGHrEEW05ga4VEEJSGqqfa5v1BfSIwt07ERatzoPojsR9FZcGs82ieD4wJcpNU6cxs35dRy/jqXe8/0r50pLAu2lGqWgyybt60mI6OOrUHS5zWofhDCGagVPnWJallb9m4/lFhHiEVn4RraZ8tV9d9nFP0Iyt+wp/1P4o8A5ByzJlwzYxrh/dY+N9FJ+HRFj1JO8hqapP7Q3/MyYjsJOJVSiyLTrP5jFtkoi7Q4EKRIkyE7hCSEmiSCNC5FXOZhs+/VNC2oR9iJl/TipgO3KaXr5Y6SfKyoGelq+oq2XvQF+Rvg/0C5e4aYEsO7VIGrDiCCx5GahPnaZsq8c4C6mia8jyL3HAJtZ4uE9kr+61w9J/lv92xii+coQuwq/vVhjRvKKsMzp0eUaZWceo/SJBJ0XMCkOuQbTUfcuxLji9R+EQKmkykKUy6bxI2QMzRHsCV/AGJW1j8jG0s0I/u/cC1hLgr5wCl8hbBzeRAiaRqQayr0KssNg9BtBLgtpmAA85/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(186003)(38100700002)(38350700002)(6506007)(33656002)(44832011)(66556008)(4326008)(6486002)(8676002)(66476007)(52116002)(66946007)(508600001)(26005)(9686003)(6512007)(6916009)(83380400001)(1076003)(5660300002)(2906002)(316002)(6666004)(86362001)(8936002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0J3eHMwbSswWnlxR0xob0tvK0VPL1k2TnFLZGZYZzRYWTNKZllNQ0NObFhW?=
 =?utf-8?B?V1pFTUxlK25Zay91Q2dzT0FlN0dXV3RzYnZTYklEbUxwcHpzbm9nSE1kcnBx?=
 =?utf-8?B?MHcwczZFYVFpdjJTZWdsbkN6TVRNR3BqUGhSdndKNnNNeU9Yc1JDTHlvREtk?=
 =?utf-8?B?OENzSWE1bXM1eXAxRnNhdXlrb3ZEUFg5cE5HV1ozelE2QkhTbkkxbHNVZFQr?=
 =?utf-8?B?MEM0dWordkdhQkRYVk1tL3ZYTExwZnBQR3RsZWtCblVZdU1NNzZOWGJSR0lW?=
 =?utf-8?B?T09tTnpPalB0SEZHZDByVGJ4aGx1ZlJ2QmxPTklkY2lCaXhncU0yRDNBSUVT?=
 =?utf-8?B?ZTJKNzVmQW9iNWdIczVpZEo4L2JveEtMNE5KWEFsV1hTdTdQR0FFNTNucUtG?=
 =?utf-8?B?cmpFek8vNmttclZMRWNpSUJZT3o3Ly9vQkFOUE9aaW1BSHF0UFpVUDFscFFx?=
 =?utf-8?B?VFpjM1RoczQ0bmhpWHpRYWFYQXZwVzIwUjBLYk9CTWJsK28wbEVma2tqV0NX?=
 =?utf-8?B?QVdqbHlOWmNzTmxpQUcxSkNzN0FUazNmOXJzSUQ0b0Q5bnd1T1NoRmw5NTU3?=
 =?utf-8?B?TjNlMzBFVFpGNUNpOWVxMit5TlhuQ0FQbGRDWkJKOUR0U2NlQmdiT3pQdG42?=
 =?utf-8?B?dkVvYWk4bjkvNmpKZ094UWRmRFZGaUVxbFlueU84Y2FDcXhJU0lCaWJOam12?=
 =?utf-8?B?N05KaTdQcTl4TlJDbXZ6cUZ3cHRCWnVlWjdOdEwyVEJleDNMTHRiK0pTUnZv?=
 =?utf-8?B?U0N3dGVSSytXaHRzRjJVa3Nnb0thUm44bmFacmo0c1I2SGlrRmpiL0NqU0lQ?=
 =?utf-8?B?ZEs0Y2lxbGJRSWNhVHR4Y3ZSS256Q0NraHhxa0lRQXFPY3VRK1Y1b25KQ0hW?=
 =?utf-8?B?Ym9LNTRFZHhlVjJVS1MwOEZBZ0lTQUJxSXdJTDlUcnFTbS82Vk1TMGNpRkhR?=
 =?utf-8?B?UVVHUkdaclBXd0ROQTkyQ3BtWVdQZTJyVHRUVXhETzhNYWwrRGdSQ2NZek81?=
 =?utf-8?B?dHFtLytkN2gzNmgvU2kzTDNNeXByT3FRV3NkajBQOFFJQm9PYkpvaURWSGFi?=
 =?utf-8?B?LzVXVUtiT2M3MnJZdlVOQW9hVENFUUh0MVJVNW9uM1RZZmkvMkpwbDFkbkM0?=
 =?utf-8?B?TENhMUdjZXlpSWxHdXZRVWRQTzRORi9QRlpJRy9McjBRMnBRUzBraDAzalpG?=
 =?utf-8?B?Slp6N0F4aG9hUXRnUW9KL2N1eWFSekVsTVhBYTFBQkFzK3BObmNCaHpkVGNp?=
 =?utf-8?B?bjhTZFUrbDFkNnYxeFlFK0tJcmlObHozdWJpd29uK3Vuc1VrVU9uSlFCbGhh?=
 =?utf-8?B?TDlSWnAwajRjTGp6eTlLT3lxNzVxcGdLNFVndEVxcElsem5TTktQL2Q3b3BP?=
 =?utf-8?B?R2pEa1lraG5oMjZkTmM2d0NKR0hmWWlLTkxua1FoNTdzVElJQlFhQS9BY2c4?=
 =?utf-8?B?MlUwbG9qQ05peUlZR0JIVlZScy9iYlZFZkJUYm5JUzJjejNMNXo4YzF3MHpR?=
 =?utf-8?B?S3k0TXFPeWJqNUg3eW1nZDhXVDcwRGc4d0pDa3AzbFV5eVg2SDdYNVFKUlhQ?=
 =?utf-8?B?WkxkTXRta2s5OVJOMndVTi9BQmtTTmxNVlkvMUJiQlk3WVJJUmdWZmlCWlIv?=
 =?utf-8?B?QnhaOVZEOCtRdHVpMVM1UXdsbnN6OGl4azlLOVNDSkdSM0lseEwvdjN5eHlM?=
 =?utf-8?B?RkhjU3J2WUwrTDRXOTBKNXlDMjE5clVERGZZaWY2MkZVV05EOW1UcXlQeG53?=
 =?utf-8?B?YkZ1bVVFcCtmbjdDYnQ1Y0pDT0tkWVljRDhzL04xYVN1TlQ5Um10WHhuaHJk?=
 =?utf-8?B?SkJ6ZVJCTmtGT3lJSW02U3h4dE1jSzdvZTRDdDFRM1pQckw0UXNpbDFtQ1Jh?=
 =?utf-8?B?b094Um5qSXhMWVJFbEwwRS81ZU1wRHYwN3BmMUtXWDVvTGxsQjByZk4zQWZ0?=
 =?utf-8?B?Zm5JUFV2UXdnQ1ErT0NFYXozOXByM0dxSytGVjRJTDcrcVg3bnpOcGlNVk83?=
 =?utf-8?B?THk1Vm1Udm93PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b300389-b64e-4f01-bf99-08da068ecbd2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 14:19:20.2774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74/S4I8gSdGSGdzaioycP1ppbMMBQ+yYpH3eiu32qYDSrlClaM9erRrEd9+4FOVXgsMScBkUHRjbdmdBB/tw4bIU4hKdhNibVgb4g+N7e1Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4198
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10286 signatures=693139
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150093
X-Proofpoint-GUID: b7yoYC0Ot07uzLJFPMtPe2e3PuyLYXq0
X-Proofpoint-ORIG-GUID: b7yoYC0Ot07uzLJFPMtPe2e3PuyLYXq0
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 10:11:10PM +0800, 周多明 wrote:
> Hello,
> 
> On Tue, 15 Mar 2022 13:26:57 +0300, Dan Carpenter wrote:
> > I'm happy that this is simpler.  I'm not super happy about the
> > if (sk->sk_wq) check.  That seems like a fragile side-effect condition
> > instead of something deliberate.  But I don't know networking so maybe
> > this is something which we can rely on.
> 
> The variable sk->sk_wq is the address of waiting queue of sock, it is initialized to the 
> address of sock->wq through the following path:
> sock_create->__sock_create->ax25_create()->sock_init_data()->RCU_INIT_POINTER(sk->sk_wq, &sock->wq).
> Because we have used sock_alloc() to allocate the socket in __sock_create(), sock or the address of
> sock->wq is not null.
> What`s more, sk->sk_wq is set to null only in sock_orphan().
> 
> Another solution:
> We could also use sk->sk_socket to check. We set sk->sk_socket to sock in the following path:
> sock_create()->__sock_create()->ax25_create()->sock_init_data()->sk_set_socket(sk, sock).
> Because we have used sock_alloc() to allocate the socket in __sock_create(), sock or sk->sk_socket
> is not null.
> What`s more, sk->sk_socket is set to null only in sock_orphan().
> 
> I will change the if (sk->sk_wq) check to if(sk->sk_socket) check, because I think it is 
> easier to understand.
> 
> > When you sent the earlier patch then I asked if the devices in
> > ax25_kill_by_device() were always bound and if we could just use a local
> > variable instead of something tied to the ax25_dev struct.  I still
> > wonder about that.  In other words, could we just do this?
> > 
> > diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> > index 6bd097180772..4af9d9a939c6 100644
> > --- a/net/ax25/af_ax25.c
> > +++ b/net/ax25/af_ax25.c
> > @@ -78,6 +78,7 @@ static void ax25_kill_by_device(struct net_device *dev)
> >  	ax25_dev *ax25_dev;
> >  	ax25_cb *s;
> >  	struct sock *sk;
> > +	bool found = false;
> >  
> >  	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
> >  		return;
> > @@ -86,6 +87,7 @@ static void ax25_kill_by_device(struct net_device *dev)
> >  again:
> >  	ax25_for_each(s, &ax25_list) {
> >  		if (s->ax25_dev == ax25_dev) {
> > +			found = true;
> >  			sk = s->sk;
> >  			if (!sk) {
> >  				spin_unlock_bh(&ax25_list_lock);
> > @@ -115,6 +117,11 @@ static void ax25_kill_by_device(struct net_device *dev)
> >  		}
> >  	}
> >  	spin_unlock_bh(&ax25_list_lock);
> > +
> > +	if (!found) {
> > +		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
> > +		ax25_dev_put(ax25_dev);
> > +	}
> >  }
> 
> If we just use ax25_dev_device_up() to bring device up without using ax25_bind(),
> the "found" flag could be false when we enter ax25_kill_by_device() and the refcounts 
> underflow will happen. So we should use two additional variables.

That answers my question.  Thank you.

> 
> If we use additional variables to fix the bug, I think there is a problem.

So the v3 patch was buggy?

Why was this not explained under the --- cut off line?

regards,
dan carpenter

