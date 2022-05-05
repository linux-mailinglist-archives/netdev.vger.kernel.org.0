Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2F151B6A8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 05:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241583AbiEEDr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 23:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiEEDr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 23:47:27 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CD547ACD
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 20:43:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knIkk+Os6VFB5SQm6pMaQvi7R9I+sJJiLpvHGMpjUMpPhtKPH/VhAJhO3/ZnQfyeNUf4P0nfuW1p862ztv1anSapcPIn9tKAUxL7ScFfOnV2KmQ1Ad/z/uZ1J+mXck1jllxPKvMyFjpETZTZnoD46iqJI798I37H6fbYZwalN3VlGf0b9nFYvy5ibL0IaK2NSGi3s9M1YZtFhfyPe8abRt3XgKDZ7AxJZ5EACaleDcT6cMOkT+h+GFJzAQVGEkGsR0DTgfQXerCZK81fsgB7UOhAocKF3YxPYXezYudNcMKPdepb9aa6nNMmfa1kYOZATq0wPVBuLoYwTBLZ3pJ98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hm2tZDqFAh/8rmtAlDYwANIb598SdCe+gEBJi2lRlcs=;
 b=LX/lBsQ546zv/tTJOPRGA9SQRcFHwP65gjCoiZh7XPl5ZG2AsZLUT9JTqDE6Y7q1P1aZ5DEDkE3if5gX2IBUDRGy2paJakU3ylj4dhRiQlIcK8FneC9Tn1FH6Ek/twzHnK42yzpgu8FSpk4HM5doolsCxMCUAUkLgcuQvyAq3rqvXQq70G1s0gVd8YunFgWtlULPTU76I61a/tSSlqqRQ3CeG2rLPr5C8wZf0EiMtXNwfeU4BNDeys1Rd3r8hak+7DWMQ/hrlAmVkoDIoEy9/SGeEqVLjgPLk2D7qL8RkMYe4bYqhf7Or7KXfJvzoOLfuExYhg5e1PhBW0ce+MVjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm2tZDqFAh/8rmtAlDYwANIb598SdCe+gEBJi2lRlcs=;
 b=cUSmFY7gJr4IAUzCrraKaRW2AhqSG87MTyybpY9nXVE892dmAhJ7DT9fmHwWSsyIXDzXe+hI/Cq29YuANH4kgXdNe+P41885AMpXG0kzal4VN3paL2SxqUY/MzX/j97PbFDt7+HiC40vnAE0OdH8U1nyZRCGEmSdNctZg3/vzxE=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 MN2PR20MB2830.namprd20.prod.outlook.com (2603:10b6:208:f5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.25; Thu, 5 May 2022 03:43:46 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::29ed:556f:c7b6:3493%5]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 03:43:46 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     David Ahern <dsahern@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYX4JgQ9a90BuNG0u1i9lIsMx3tq0PTj0AgABUASQ=
Date:   Thu, 5 May 2022 03:43:45 +0000
Message-ID: <DM5PR20MB2055CCC42062AF5DB5827BAEAEC29@DM5PR20MB2055.namprd20.prod.outlook.com>
References: <DM5PR20MB2055102B86DB2C2E41682CE3AEC39@DM5PR20MB2055.namprd20.prod.outlook.com>
 <20220504223100.GA2968@u2004-local>
In-Reply-To: <20220504223100.GA2968@u2004-local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e70a01d-b2e2-494b-de7a-08da2e497523
x-ms-traffictypediagnostic: MN2PR20MB2830:EE_
x-microsoft-antispam-prvs: <MN2PR20MB2830C540DCB38363BEBDB197AEC29@MN2PR20MB2830.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jrxbrv0eLp9UJtRsjdeIhQcjnqYWeODEsr3UAwgK47KkVhbDFIa0uIbKssfBcXhs8ZhcH+xTkCIQ3Z1bIxuUGARnvGA1xGX8id/1VEfsgzjEOKA1bCjM4Yhirw4LbHAs8R49gIB74Ok4qUD11bhgwK2hwUEDA4k8uljn7vVlNp0Nr6CtqwAa+EclDxx2D4rxxwJmYy86alxCRDzG36dDYMx29n93OPEuVTrfD7+zzRguG0x/ei5GHFZRtNzoZOPVYutFcnhRd3h1PlWxoAywiMNmwIJMfj+kC1V6A8PIBPYqOzAV1tirr5XjKSp99yBGKABX+H57k+Jv79fkQzu4mBm48LK2vNkBc31x7nNt6g9omVEYJp0lCMzRMDoiP7+J4F+wji8Bu+IwkDUb4HTqZVhJx5qM9mZYQWKlE/HjxPU5eFOdM4foB8LCOjJFVb0sWrPI8vBrQ+IydzzbFXv3n+iSJsWTNR9RzTTi5Xs1wD59Ei41EX312WBUQjvZoyHV7/7z4VD5fHzvbNF6PuvU9CvPWj1DxAfayTyP3Vl9gq91h8bRImnUqjPEjFZiCFXOosUhIjPhnTU7iAAF3e4sqlz+TjDzyqTcAaor6gkvyDSNlvAv4IXGMX2BXv8H73m7CQeth085dzXHXuQRRnBm2fvGFJuHVchvh84yuQQ1EYhXoEHvCGq9yTIqPvyFdudu9VDkiZLMxFokRahkVZzZVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(136003)(39830400003)(396003)(376002)(346002)(2906002)(66446008)(5660300002)(9686003)(55016003)(66476007)(52536014)(71200400001)(83380400001)(6916009)(91956017)(76116006)(66946007)(38100700002)(38070700005)(316002)(86362001)(26005)(53546011)(7696005)(6506007)(8936002)(4326008)(8676002)(64756008)(122000001)(33656002)(186003)(15650500001)(508600001)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+ACenhPGR7Md4Qk02uv2PkapyrNK56ZkI4v6wyM++3hTvUIM9k8JMc5gZ8?=
 =?iso-8859-1?Q?iLI1XytlwleCBgFvvGRj92wvCoHve+XAT9gOH3cH1oao169kPO9SH6nvjP?=
 =?iso-8859-1?Q?i9qbVZLmxYfWHXHcp1xs22EgVF3tjGF5NZn9a9JB8brKTVsQPNxCx4JBw8?=
 =?iso-8859-1?Q?WVDRiHi/XAMu3FkAKiQ3nbzV3fr1WHc1H2ctIa4ZWYesdZ2lYhik/DHHUF?=
 =?iso-8859-1?Q?hf0v13LaYgd+eSrhtcUIw9DtZfRMPxHf2qXbqqpuc9U96Ius0+3j5PokWh?=
 =?iso-8859-1?Q?xfmd9sg3Xr/128rc1KgV0dXAmm0YNst12BDf7rf+8pMJ+2qgvDnrVA5SvN?=
 =?iso-8859-1?Q?qWPMyocYRxhPbJB3aJlfxDh3NxakiovEu5InautTc+lNICF+xVnZXSZi/y?=
 =?iso-8859-1?Q?ZZT4Vy2i1p+l0oVzouq3PCSXcxQ4r+++ph4ecuDFFr69drVp0En2r6r5TQ?=
 =?iso-8859-1?Q?X8yzccJUyIcPfyZFFgOOjpFE1pLhWygo1Yp7QUEb4PUOfVEqbjLlCYmrjq?=
 =?iso-8859-1?Q?ZSH3HvL1x3Lyx+g8Xdm1xjkIB2eGVK+bqN0Hm1yN51w6WjfI2NJOBwGpDI?=
 =?iso-8859-1?Q?000pYMHLLrHPvd5B1eWjUQAFNhzXsPPephH2vMJcwIcsnB9491snF6akIt?=
 =?iso-8859-1?Q?7i/3V8aYB2zPI1JcMXFdwwL97wpStHEn/2axlUmrRMRI7jjsfozK7I6nMK?=
 =?iso-8859-1?Q?mj9KDCvt4yqWVPtqnPv+rzLgf3AY8GHm57fXJdjg7pQoVxpHpe6+DuY2SW?=
 =?iso-8859-1?Q?4b34CMCwyXjWxncKo8vqoGuglZzVVx7AQ57bqegfrbJ5NdHGgIpm1iEwVI?=
 =?iso-8859-1?Q?yrfRah6etuEXBZNaf4GTewDK/b01PSA8kAKm3uJxL2Zy1cJMAQSBIILVWV?=
 =?iso-8859-1?Q?OfNpfTvzPRKo/fvDLuIRktHpym8l0OZZ7VPPpWf+HOu3se/BKzrHP5MFoq?=
 =?iso-8859-1?Q?0jQMEKeL8YkwkjtntDvFn8VFtCZKBMbIGqHLNBET8h/mDhCQVxXJVbbq5K?=
 =?iso-8859-1?Q?kCsCNED1Bqd9L1HgV7NKp8uvpiCPgMsqS5O53g1JW9Pnr2tLP6VIZz+w+b?=
 =?iso-8859-1?Q?Z343Shm2QHqRn0ctXq+LDO5TPPGYBVBz/Nl/z/8Rpwkeg+QXnkndVR8HDN?=
 =?iso-8859-1?Q?K6PnVlaytKbdAjoSVmT4PtxBso+ttBGlprdCpQE5aH+JbFN6bEe5oguKaw?=
 =?iso-8859-1?Q?Nnllt6/E/DqPZlJtnaNsIlBy92emjbogfIE+153vqLrSv8RYbtyv4JczTx?=
 =?iso-8859-1?Q?5mgtJGtvvRlxsYbbqQYIv1xYVCEPOHOJDO0hDa60UEDBnPcK9pvsEIFhCq?=
 =?iso-8859-1?Q?edmn/44M8+xygOhu0A+WYUAAHiT3h7T5W5nwRyIPyhUHljx83W0Msv/gCU?=
 =?iso-8859-1?Q?3Opcmnq6cXimlSSu8hglh+ytBvbhmr7wF0x2ANo2wjcvexyhDVVSyx1QcR?=
 =?iso-8859-1?Q?NFAtp1+e/0Eir+DHDo4vLsk9wu1qErkKQuInaxYzJpHIdZ3bX0aCbWAIht?=
 =?iso-8859-1?Q?YCgDt0FZEiXkEZ8bwUV0oiptFS5k9uxf7bMBFsuHkZHUeCcRn4twa8noKV?=
 =?iso-8859-1?Q?ML8ixwoxur3Zl0opLVxiJoYWqb23jY/44J7suAIe/452ukVBGZRli+N30A?=
 =?iso-8859-1?Q?asuci1lKO3WKYFtGsnu5jl/pcOLhfvhreslmkyMHK3+RK+Of6gkURNjfZE?=
 =?iso-8859-1?Q?6BbiU1237UW2vXauaHbIHwVc4uv1HYD2FpSyLzQLa9rGV0yhAudIzfgGTO?=
 =?iso-8859-1?Q?IuZLSQNv9c/Bn3EXg4EIfDOLiPA/E/yGnEstc6mRj0RiUwrV2wxgbL+k5a?=
 =?iso-8859-1?Q?5R+ExXPevA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e70a01d-b2e2-494b-de7a-08da2e497523
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 03:43:45.8809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvBUl29/8JI0XRT2pEQljJHD4QFOzcRqS/zGF/247AGMUG8dxsHaf5BRdcKEgsw+ozEYoHbFkSPDty9Hiy/A1zjO8yiUp/1aQrs91iuDv8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB2830
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,=0A=
=0A=
Thanks for responding.=0A=
=0A=
The librtnl/netns.c contains the parser code as below which parses the MULT=
IPATH attribute. Could you please take a look at the code and see if anythi=
ng is wrong ?=0A=
static int=0A=
rtnl_parse_rtattr(struct rtattr *db[], size_t max,=0A=
                  struct rtattr *rta, size_t len) {=0A=
int attrlen;=0A=
  for(; RTA_OK(rta, len); rta =3D RTA_NEXT(rta, len)) {=0A=
    if (rta->rta_type <=3D max){=0A=
                clib_warning("rattr type [%d] ",rta->rta_type);=0A=
         if (rta->rta_type =3D=3D RTA_TABLE) {=0A=
           unsigned int rtable=3D*(unsigned int*)RTA_DATA(rta);=0A=
            clib_warning("RTA_RTABLE type rtable %x\n",rtable);=0A=
           }=0A=
         if (rta->rta_type =3D=3D RTA_OIF) {=0A=
           unsigned int oif=3D*(unsigned int*)RTA_DATA(rta);=0A=
            clib_warning("RTA_OIF type oif %x\n",oif);=0A=
           }=0A=
         if (rta->rta_type =3D=3D RTA_GATEWAY) {=0A=
           unsigned int gw=3D*(unsigned int*)RTA_DATA(rta);=0A=
            clib_warning("RTA_GATEWAY type gateway %x\n",gw);=0A=
           }=0A=
         if (rta->rta_type =3D=3D RTA_DST) {=0A=
           unsigned int destip=3D*(unsigned int*)RTA_DATA(rta);=0A=
            clib_warning("RTA_DST type destip %x\n",destip);=0A=
           }=0A=
         if (rta->rta_type =3D=3D RTA_MULTIPATH){=0A=
          struct rtnexthop *nhptr =3D (struct rtnexthop*)RTA_DATA(rta);=0A=
          int rtnhp_len =3D RTA_PAYLOAD(rta);=0A=
                 clib_warning("RTA_MULTIPATH type\n");=0A=
           if (rtnhp_len < (int) sizeof (*nhptr) ||=0A=
              nhptr->rtnh_len > rtnhp_len){=0A=
                continue;=0A=
               }=0A=
          attrlen =3D rtnhp_len - sizeof(struct rtnexthop);=0A=
           if (attrlen) {=0A=
              struct rtattr *attr =3D RTNH_DATA(nhptr);=0A=
                for(; RTA_OK(attr,attrlen);attr=3DRTA_NEXT(attr, attrlen)){=
=0A=
                 clib_warning("attr->rta_type %d\n",attr->rta_type);=0A=
                 if (attr->rta_type =3D=3D RTA_GATEWAY) {=0A=
                 unsigned int nh=3D *(unsigned int*) RTA_DATA(attr);=0A=
                 clib_warning("gateway %x\n",nh);=0A=
                  }=0A=
                }=0A=
             }=0A=
          }=0A=
      db[rta->rta_type] =3D rta;=0A=
        }=0A=
#ifdef RTNL_CHECK=0A=
    else=0A=
      clib_warning("RTA type too high: %d", rta->rta_type);=0A=
#endif=0A=
  }=0A=
=0A=
  if(len) {=0A=
    clib_warning("rattr lenght mistmatch %d %d len",=0A=
                 (int) len, (int) rta->rta_len);=0A=
    return -1;=0A=
  }=0A=
  return 0;=0A=
}=0A=
=0A=
=0A=
=0A=
From: David Ahern <dsahern@kernel.org>=0A=
Sent: Thursday, May 5, 2022 4:01 AM=0A=
To: Magesh M P <magesh@digitizethings.com>=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>=0A=
Subject: Re: gateway field missing in netlink message =0A=
=A0=0A=
On Wed, May 04, 2022 at 06:46:05AM +0000, Magesh=A0 M P wrote:=0A=
> Hi=0A=
> =0A=
> I am trying to configure dual gateways with ip route command.=0A=
> =0A=
> Ip route show command shows the dual gateway information.=0A=
> =0A=
> I got a vpp stack that is running. The communication of route entries bet=
ween Linux kernel and vpp stack is through netlink messages.=0A=
> =0A=
> On parsing the netlink message for the route entry with dual gateways, we=
 see that the message carries only single gateway. Is this a known bug ? Pl=
ease suggest a solution to resolve this.=0A=
> =0A=
=0A=
If `ip route show` lists a multipath route, the bug is in your app. Are=0A=
you handling RTA_MULTIPATH attribute?=
