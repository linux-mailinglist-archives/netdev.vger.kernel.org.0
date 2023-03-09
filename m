Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88A06B3025
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjCIV7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjCIV7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:59:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E6910822C;
        Thu,  9 Mar 2023 13:57:31 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LnRUG020784;
        Thu, 9 Mar 2023 21:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jRWWCAwsG1Mu1RZlDRp+/hJ68Y7FF/Z6u638c+lm+EU=;
 b=TPoDuUlQYFbWTLuyS05hFT2kx006br9Otct8QiHuimqC5Z/HMRRP+WMT0dzh4daxiAMB
 4meLrfmLnAFG2uqrxwlTCvOa/W0NRIdzOBGQiZgj/gUt8iGWbveSxIByPBXmIxnAEZTp
 Z8YSiBibjaISv0ZuYURG/acRnDvnDsxbzlGIhMdSoPQWe8mmt3VTFouoE7dTgsOunIbM
 mkkfJH/uxV4JmzqyMVmDi8L5DlcDU24pvH5gKopnbq5kNxOxrYfvhiKFFXKDDw5uXRbv
 LbOXSyiMZd4Yb5lqplerP7YiyRbuvjSh/tgtGkq8gekksMwAm3pMztYhdBPJ0fAx0pUL 0Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn989nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 21:57:11 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329KkT8E021673;
        Thu, 9 Mar 2023 21:57:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fraw8ka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 21:57:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0A+brpooRRU6Dayf/Wpw5beLN/gnIw0JivRL0iicfctQs4tS3RBcn38/fDmaWNNlV9zevhmQDSirvPlMNN7PdjE/nR6z7oQO2gnFrnXFDA+ol8GUVusakEqoqPryL7NJpMxFbjTBwVIVNVgBet19CVeglCQer3XuALKXdR9YCjip67agNayQmf5OxcO9vptpZM5N6+KLirBTOmwOemY/z3G+D4pZ9Sc5ieug589YV3yw3M9TEBj8q8m+lF9EAVF/Mdbu33dANWyOb7hM971wTFjWJCrTiHy/bB8Aovc6DxidK9fZaRY/5wcoEjekcpzAIs2I/T7qA9hUVQhPmDjhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRWWCAwsG1Mu1RZlDRp+/hJ68Y7FF/Z6u638c+lm+EU=;
 b=APg3Gjzv6KPqKtvxPgODkLIoM2dFb6yxywy1S07pSExoikUTS21AlMzvzjCia+Da5k5yC9I9aickA/lw9GLsU5RYiwT2jn9rXUy0DQP/ThG0Jxo19DT+NtOXkCwczX+oyUB5GqY76+LVwpqCDfDG2lefz4pfWQUOBjYcEBUymUkpjzKgSv/HevHd2SbUWRwBohcDsGHevxKfFEuuym1/cQxTUrRjyWxRrhSrdi0A9jUxKYRtlJy2upmibHACy8vv3NHQ3WhHD1qoLAk2EkFBRxEbRZXPNLYPhtlzz4Q4oNEklZq7xnB0W+TqrFeLhjzGg4zPAzP+8gdT7izeNBRHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRWWCAwsG1Mu1RZlDRp+/hJ68Y7FF/Z6u638c+lm+EU=;
 b=lsEElz9fqi6tPpjzuUQMbcZidrHCO7MuVNgw3VJS7rh4bFX34D0VfKHPosdttil8ZQobfj3LUtUjViSZhf/pdtPvJ15HWz9+H5qstC3xllWVl5K8D2ELYxb25ZvY6UCgALoQaUtBVIQTpVnK4a7DlAbI29ZoFskpz2/4R690WqE=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 21:57:07 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 21:57:07 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Christian Brauner <brauner@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Thread-Topic: [PATCH 4/5] connector/cn_proc: Allow non-root users access
Thread-Index: AQHZUjeyrMgn8OBC9kmPq73sfHhYva7yr1+AgABNgZM=
Date:   Thu, 9 Mar 2023 21:57:07 +0000
Message-ID: <BY5PR10MB41295E661E7CF2B56CE95F14C4B59@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
 <20230309031953.2350213-5-anjali.k.kulkarni@oracle.com>
 <20230309170927.jzeksgqwstd6vunp@wittgenstein>
In-Reply-To: <20230309170927.jzeksgqwstd6vunp@wittgenstein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH0PR10MB4470:EE_
x-ms-office365-filtering-correlation-id: b6570578-142e-4e34-5377-08db20e939f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XC3gJFbkkGz1WEfdXZy3ajeVr3RwYK5JMo7uptXuGReq+Cz53ZUSzoRCP+zoZwAwhlAWrCr9HxoC2RJGG2HewNQVkPTfeADGB2E7y57Zow3NFsaL36dLGAy/jy60EYKZq5xGmaGwyg3bj7TIkNeiVpdVbzSyQA1vo3friiSrbYsDDfrjfx/9z+H8cxLDEORwWBPUP8fkREGCOUoovbo4Ee9V6/Zy77yX+WGPKCQud9LDB/xc0uWCAWXHsO/qUYtUqeuRAgoxSp3jumpr2SHJ/Mh/uw3O9hHVo5urbvNy5MDlQWDyFSnxPeeXOhUuFHBW8UWyzGemgbhMZA+ukcFe17C8FwD8gEzSbSxLv4dPO8f49krnu8bG8zcud+uNNHn8yuTLxFIscCXqplVUVMj0vM9UcqH8HORe92/Pc4PUs65a/Z5dmDmCOhMmzZb+xLE7rAgTAH4TyPN9Bngm4+Bq8WM4IBbM4xKD9yaMOht/QfTEcf8YGK1UD8Qbl0oFh/DEXrxMkenibAsLsUXBgNuCA4/b00eEDZrYvK4Okql2d1cxYbPiv44j/FnBaZdwHqSgr3+DtLT9PbDoYEaCaC73agvimlHC2DzYioQwyLJ2nQ6qpJm9+fsG7UYuhelkj8MSFSjXYECePXq6+bdHVYRqiexsXX/ELuukBnNgcqPLqceE+lCRkE7mBq8E8ntC2JSZAvEQif4eJJBIgy4MqtdsGM+bHEwvnhKCBc6XtHxyv0NXg6Vh6UCxoknEkSvyHAqt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(376002)(39860400002)(396003)(366004)(451199018)(33656002)(9686003)(54906003)(316002)(5660300002)(966005)(478600001)(71200400001)(7696005)(52536014)(7416002)(8936002)(66556008)(66446008)(8676002)(76116006)(66946007)(64756008)(66476007)(4326008)(6916009)(2906002)(41300700001)(122000001)(186003)(38070700005)(55016003)(38100700002)(86362001)(6506007)(53546011)(107886003)(83380400001)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jFcebL3jZq1fkxU/wbC2iTrXtk+ESNBCvMTMLwZwWpxDartAaPCdBli2Fc?=
 =?iso-8859-1?Q?LX55iId+nF6D5PuoJZqmvHOLmxzzjVRF2loD/KTEzzwRb7NCjPjzmgr3ok?=
 =?iso-8859-1?Q?rl67sPtijwweL0Wtlb/7JvQfnWflVla1Bj3EuqWiSWNDk+kqFBswV071/w?=
 =?iso-8859-1?Q?VrNdPfpbsWWwITBbEPzpZjtIUn9Psk43r9AHVR+OfqQnb2iOHKMms4FB/Z?=
 =?iso-8859-1?Q?uwngeOQ4FJOcA/Fd1kS5bl6qDc5L6dlanqpKbh+Uaw5rdDkLZjU/JpFoWG?=
 =?iso-8859-1?Q?9r3HeYFUSD8PlRVzD8jIAj3JDnEtCMosgw3RbT51yYrvQQ62jSu/ab/jwm?=
 =?iso-8859-1?Q?2sqr5CxFcocHZqXCo2HQJ/3/qOj/+08FITfkD9ZFLBa7ZkviRkmz5qsgmc?=
 =?iso-8859-1?Q?SR/yqh67efVvQ74liJ8IkQpbmAb4ykAvz2M4JqTwwW0QoiXKVh9ffWmZRN?=
 =?iso-8859-1?Q?4DhCaK9gHfou55lFGW1Rl0xANPPx56fpe5N8t2St0Qv2HUtIyhaXRKv4BR?=
 =?iso-8859-1?Q?feUW/jkQesA6NSUjvKYFVHbYiz9BjIzZgkcBkn4kekq7EDfOnAPDo/oJBi?=
 =?iso-8859-1?Q?P3bbxZdbYLQI2d97sXKaONeNF++d/rL7pBFtDOUgtViFj0jrcdvFE0bWEC?=
 =?iso-8859-1?Q?rcO5sldi5gzxu+0VePFV46+sXeZ5d3psNa7hm0QLHxV02h0DhmMHnt89AE?=
 =?iso-8859-1?Q?UfoS7uR6ueK65XoB00rqOvnpE2F1+LirQgeKFVvQITf7R6bvTr5bEyaxEz?=
 =?iso-8859-1?Q?gJ3M0Z/JKv4aclmBLQNIjGypcTRF9jd/QwO/nolvalD/UrdGY4wS3YUbzT?=
 =?iso-8859-1?Q?ObZlUlFLXS1iK7ywViMDPAGxlG8mVdJlRcSUXurSkGdEzQITHPze2qIYk9?=
 =?iso-8859-1?Q?U8CMJ1iMiD1eHUv7WG2C9Bl+JMeYQFrvfszR4fMoITYerXBLeEto73Zij4?=
 =?iso-8859-1?Q?gCme3Lr8EisyIzqX20iFjAJWWjORpfQVDoeNKiIkog5TtjlA1bxbDMXvQV?=
 =?iso-8859-1?Q?SA8RPs9usKdB+zMBKIdYdEfIs3ZcT+AxzE5tMTtZo1AJH6GCqBR0o/UoOQ?=
 =?iso-8859-1?Q?hW/0ZFeHBIUPFGcbcqcOyszqSnvZcGCxtzTrRT9XlcVJ1cavJbIEAI1tPz?=
 =?iso-8859-1?Q?XZCafzJi6S7ja9OCWdn4kEtL4UJwkS4d9a63bjX6RdIeQN2Bj/siwQ0QSm?=
 =?iso-8859-1?Q?uu01ZiGyciyNMolXPTINryWe0t03ywvIRCN3DyOj2EkNVSda6AUNDB7Z2s?=
 =?iso-8859-1?Q?V6mXLBE52nZjbsFiCLhaquWiLiN3fI/10akiuWMmGPey+pnr2vkZ8Ox5dU?=
 =?iso-8859-1?Q?tZml/svJm3FhPqoHWGYUUAe1BDhO7vTH7CJZgNaiK55gD7D1icRx5vVj8Q?=
 =?iso-8859-1?Q?Rym/cccMWsW2mbOXl8GbTeqczxeOedmZdYYW92K/NSh9UmHo2mKfaQuuQp?=
 =?iso-8859-1?Q?h/5Idsw+5s+8NeChrChpF/aAs2pxQMRsDo1p9uMWz0OdVGznwN82w6NM7t?=
 =?iso-8859-1?Q?hpq5/SDUEcwz4dC9ToybT9OtuY/gUg4CLXNWT21Du+uA3ayqB/WnNvvAaT?=
 =?iso-8859-1?Q?55PTJ8kbMidBQOtZp09oRESQjtZwhYXDEuL+G/9WkxHN2G1w3mRve/AdTy?=
 =?iso-8859-1?Q?j6lzliHLvfW+vlnLLqnnPhBmI0jaPHj5K9YvhuUnTyoM0G5A0W3JOAwmUK?=
 =?iso-8859-1?Q?Ugb8JWbR1XmMYu+ct2g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?/5fXKHmL8spL7cUdMDt8IfVbQKlQM14yAaxBVOtDqoKu8vqQBRsHaldDXq?=
 =?iso-8859-1?Q?naENY1aBZK7VxMOEj319GzpoY+ukPdoE4MCpmTN/z7YD0IQxX+5mFTw0y+?=
 =?iso-8859-1?Q?ZnCZdpBQds5z2ju1zIrjLhfWRKBHpFH4i0s0jY5o/GOFdkwdRKqejHxLda?=
 =?iso-8859-1?Q?alWSMUbCRY2u95GJ7YenX/adl4HzaemLq4Hal0gt+fZ8XPz4dJzitF1dsJ?=
 =?iso-8859-1?Q?0GfA0HTKXhAnXHe3YPgHislzmPMM9m8J+q0jThO8kIZhDPK8LPL8xDygfh?=
 =?iso-8859-1?Q?riitcGetfRXlbBdKRS5kt9ImLks4OAvWbAdJ+7LSs3FOPp6oxwOTlQOBMh?=
 =?iso-8859-1?Q?kPj9SHKv9k3kj69COM4xKhN2LvL9FDIiNuZRQnUsnebp5wWO1p1+4GncaZ?=
 =?iso-8859-1?Q?llJLc5+gZkzGyBbaDAdnOfV/plQDukoK22n7APpDJ3Bs9ToFhqjqdGaubI?=
 =?iso-8859-1?Q?XUOdKllbgS1ugqv1axry5clcm6g/fT+m8HxoP+BxoqbEIcoWnwYeEDa0qX?=
 =?iso-8859-1?Q?Bd9qCRUdiKYw0VFNq62weqO1+GnIa3QgqDaDnaHlSoEellrJMPOHFRcpBr?=
 =?iso-8859-1?Q?kcINPqbC1w1iyKIhRCIoRQkbYSggHvYYzLvoPTaETWbcSk1zNGtMoT4FVx?=
 =?iso-8859-1?Q?AQYql01ISs8010pIM3V65y2UxIAJeH0M9DEylNCy5hfFrBPxWpoPaddCX/?=
 =?iso-8859-1?Q?NcyJLC4VpRBENHk1n7y+CYlYFHoU508sCZdhvloyWQUaZ33X4Ue0udB8Kl?=
 =?iso-8859-1?Q?aYyB6pDsdbJldJrLKJCeUf1yZUP0ygrlwYFWNhyCFNeIL9eawX0TLhcK2Z?=
 =?iso-8859-1?Q?ZkaGksqTdDT2vlkEmM4wHbC4+At01CCiKAnmfuShP77VbBxsrlkA9Z2xbp?=
 =?iso-8859-1?Q?47qKpvWjzXixWB//HRjqtJXOq3bVsLh5jKaISMZ3PIiIATxZVAwUWY/Ydm?=
 =?iso-8859-1?Q?j1TrGYq/YD9QOEw5sYYgN1azBqALdtl0b9qLwhsbPTydlGL3YwlZpfRUz6?=
 =?iso-8859-1?Q?KjgjDvriOvsAo+ifGNPGqZ58U5Buqv0B8W2irntdjU1wVurqrnoqD8ba5J?=
 =?iso-8859-1?Q?zn6tow2VpvVQGAPgMNBsnQPQ1DXizlIfn+WA6fZbLWCM0N0YeiwEi9l2MO?=
 =?iso-8859-1?Q?68hWTO8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6570578-142e-4e34-5377-08db20e939f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 21:57:07.4542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kLc97SFOoPjpMOKOM+bGK9ASxbLjbeLnQTGAcXc0Vmoj7hsxS8Mm3sP252l+C9dP/OYTHt9M7YJCDJlCvKc1wOF6lFefIcKiPsVsKx16k8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090175
X-Proofpoint-GUID: rBBzYk_q0EsRNzMa9KMi9nkZqjVrWhTQ
X-Proofpoint-ORIG-GUID: rBBzYk_q0EsRNzMa9KMi9nkZqjVrWhTQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: Christian Brauner <brauner@kernel.org>=0A=
Sent: Thursday, March 9, 2023 9:09 AM=0A=
To: Anjali Kulkarni=0A=
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; zbr@ioremap.net; johannes@sipsolutions.net; ecree.xilinx@gmail.com; =
leon@kernel.org; keescook@chromium.org; socketcan@hartkopp.net; petrm@nvidi=
a.com; linux-kernel@vger.kernel.org; netdev@vger.kernel.org=0A=
Subject: Re: [PATCH 4/5] connector/cn_proc: Allow non-root users access=0A=
=0A=
On Wed, Mar 08, 2023 at 07:19:52PM -0800, Anjali Kulkarni wrote:=0A=
> The patch allows non-root users to receive cn proc connector=0A=
> notifications, as anyone can normally get process start/exit status from=
=0A=
> /proc. The reason for not allowing non-root users to receive multicast=0A=
> messages is long gone, as described in this thread:=0A=
> https://urldefense.com/v3/__https://linux-kernel.vger.kernel.narkive.com/=
CpJFcnra/multicast-netlink-for-non-root-process__;!!ACWV5N9M2RV99hQ!NKjh44Q=
y5cy18bhIbdhHlHeA1w_i-N5u2PdbQPRTobAEUYW8ZiQ8hkOxaojiLWmq3POJ2k4DaD3CtyC9-C=
3Cnoo$=0A=
=0A=
Sorry that thread is kinda convoluted. Could you please provide a=0A=
summary in the commit message and explain why this isn't an issue=0A=
anymore?=0A=
=0A=
ANJALI> Will change commit message as follows:=0A=
There were a couple of reasons for not allowing non-root users access initi=
ally - one is there was "that at some point there was no proper receive buf=
fer management in place for netlink multicast. But that should be long fixe=
d." according to Andi Kleen & Alexey. Second is that some of the messages m=
ay contain data that is root only. But this should be handled with a finer =
granularity, which is being done at the protocol layer.  The only problemat=
ic protocols are nf_queue and the firewall netlink, according to Andi. Henc=
e, this restriction for non-root access was relaxed for rtnetlink initially=
 (and subsequently for other protocols as well):=0A=
https://lore.kernel.org/all/20020612013101.A22399@wotan.suse.de/=0A=
Since process connector messages are not sensitive (process fork, exit noti=
fications etc.), and anyone can read /proc data, we can allow non-root acce=
ss here too. Reason we need this change is we cannot run our DB application=
 as root.=0A=
