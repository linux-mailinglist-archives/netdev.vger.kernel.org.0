Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C7B3DEBBF
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhHCLbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:31:20 -0400
Received: from mail-bn7nam10on2112.outbound.protection.outlook.com ([40.107.92.112]:5066
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235426AbhHCLbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:31:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8pDOWHgVC945MCj7/yImA1JvQEky2CqRf8JcB1EwwnuQAjB4na+kpnNXpI8HtGHYmzJJ85N6ycsir/OIiAlY7K0Nl5NuwCi69+0tqvTOBs8VBKgEOpEeSsDZLHmqI/XKgZ5q5Kikw02y38BcyL5taQO6jKp1/Pt5WVDiSL9fGObgtiAHFMXjPDwuYXsCyV8G8lmEVO/BsKdoYmWKqOhujHJ+5C+6VPYfonpOZ7tQxZ0+KkE/4OshWobPMLluwpnJf8lBQQJthP0LP9m54mU9W+sFLlRhmnW4UvF55Fb6osgI8x+iItQRBwe5bH2FKCgPnupSPUTSx6fKhBceL540g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOUJIX/vvcJlDd2m4wQQZBj4cngCGeh0aTBb6KQOcoM=;
 b=CDU7QqL6HcleJbNVus0PJtl8a3P2UEBcBQR+gp0ASVCnb6gg9S0RxMWkCep8qH/jK6sLXr1K8ja9wV/7w250sYUZrrdLQw237lgBgF3D+MTK++5TCK1tCCp3rtY25eIov7Noh6EUTcbmzxI6fLdx2f9ykWz81Ji49ReTUqg/UYeVR1tYVCcMgQcXNlkkGNDg6IKIafGDpr+Dw9NRyzwj6e5doTVK3nxIMwgvluyqA2iasrSXO7l8Q3+EMUzuoS13+quhPy1GEI46wQliAYs9SoVpjfvub3dxWnv17/eNDA3xN2zju3Keps5MIf4VPS7Iy4gkgPwIgTX4jdb8kHZ3MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOUJIX/vvcJlDd2m4wQQZBj4cngCGeh0aTBb6KQOcoM=;
 b=Tx/qPUkor0fKd20w5RAc4mDNCjXJ4QjnQeUHH691Es3lhBSqWA/7YCAQDoHQy0dPnH3ZNyYgV49LfojOMWYnRnXJA5y6QO1Kz7cFo/XudyfXWp0PKGz/yQ8OkIqXmaz50ZmpSm7TppnO4S0PDZvJecVEHp2aTscH4a/UFKbvJD8=
Authentication-Results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4809.namprd13.prod.outlook.com (2603:10b6:510:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 11:31:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 11:31:05 +0000
Date:   Tue, 3 Aug 2021 13:31:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
Message-ID: <20210803113057.GA23765@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <5e1689de-0448-e4a7-9714-86189549ea69@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e1689de-0448-e4a7-9714-86189549ea69@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR03CA0078.eurprd03.prod.outlook.com
 (2603:10a6:208:69::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR03CA0078.eurprd03.prod.outlook.com (2603:10a6:208:69::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Tue, 3 Aug 2021 11:31:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c468c439-d990-42b9-6ffd-08d956722e77
X-MS-TrafficTypeDiagnostic: PH0PR13MB4809:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB480979E54FAF1A585E7974F8E8F09@PH0PR13MB4809.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cl5pIQlG13eeUtjn9rRID1+CyoxgEdqAFGicHqeyH8ai8ctxxP9OxCKX8cKQtM9NAkzzwP3CqSOQNaESh6icIJ3fyPj/GH32Lto7Ma2gwfqE08MB4wpFgCOjziDqa1AINjrh/xuiUPOkKAw+ule8X8EypDi6I6V4F7eZQjYisgnyYR0uIKmQisK3njkG3s9ymv0TmU/GYaKEK+YIw1ut9T5zHxvFbnPLZ22VXTwvchMIgkEcYDSSlvewByIFyvXQncRX+WXe9/hSyyyea/lcYKyV/59lvpoJZvq+6OpDFare1U+aq8cGv3pAprNwEnxvmZc0a7nTQsAP57Ryg8i8861aBPahz48SvwKqxuhOV7ZaV9AugeeTlvuGbgotG9jew+N9ufolMN/NY83TGDDQrwunw9CMGyHMDXOi2d8C6ns5GCnJooQYWM6z/7jiDDWUTAJx+2Vj9FbesOmbOQ+UEiUtXl92VSrcE3Syiupmk7I87AtkJAubpSlYJ3Ay5WcpJr2ILG1G79TCByMog+WIc8vEcbgl5lQiSlwvVVM05TxlyupJyvHn2Nkq6YpdVeXkpUXlZqJu7ky8B/VvS3MPpjs1XvFrEO1TtlYeT4D0eU8/9/smYef5SHVtGm2quz8Ld+fDO8iDZwbKdlbnwjjxCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(39830400003)(396003)(55016002)(186003)(86362001)(478600001)(38100700002)(83380400001)(1076003)(5660300002)(6666004)(6916009)(107886003)(53546011)(33656002)(4326008)(8886007)(2906002)(54906003)(36756003)(44832011)(2616005)(316002)(7696005)(52116002)(66946007)(8676002)(66476007)(66556008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ak8IU5gUTOHfuCs5J3lfHE9g01Ic2rB6df+Lknq8olyKPEPttFjXEdkQ6iN?=
 =?us-ascii?Q?Y5rzwppdQzzaJhwlelQHCi+6DC8NG75I/2j2rJ4tfY6DbtHPylSSI7KNp45G?=
 =?us-ascii?Q?4h+FHj81+YPF99W/QjLx7eo20pkgik6ALgkINJZbZADsOnNrwTcsv6yG1vxQ?=
 =?us-ascii?Q?Y7Kx1UNZ5Txxjsw8ZZ1tXMwW2j2DkWQBW24JPxvqEu99WiCAnCT2fk2JdGQE?=
 =?us-ascii?Q?EbJukW66AkUwL1FZbFdbhgyLRcl1R2T49aZgKbMbtpklx6Uc3LgDmLIfTS1Q?=
 =?us-ascii?Q?HgpRvUTOE33i375B6n02LAxBHTreunF+HXU3fhnMtdzqy0qty9+/a96ASoDP?=
 =?us-ascii?Q?a9ZxfHHe5xOkZ1bnLjGdC/9sTVZ9MdiRLFnTZm6zeDvCCOsueJhtOULddbNe?=
 =?us-ascii?Q?cPJlW2M/DpGRnNOuhcDw1tMwl1i/zmzQPGt+EjdaN7J/HJrsx1vqlXrKuFnA?=
 =?us-ascii?Q?p1O3bXSUki896CLj+zj9ptdwYNoVB4Kk7mRrTVaDWmz3noxGbfuQmXBkVBW7?=
 =?us-ascii?Q?QvAxkfTUWoqiiMNdcqPRetzIsmkgKlxjz8RIru6mccB0Dd706KvBlYcpoPrp?=
 =?us-ascii?Q?/nO2gscKIOZUCsSEXq0LJEjcvN+1qGFwS47nb/adrRvNrx4vfHSa0S1RsK0l?=
 =?us-ascii?Q?WjXqrh3Y6gYmd2N0wx3jgm37nWFDza3a6JqNmwiZBX09O4943u5A1Kv96BGL?=
 =?us-ascii?Q?gvz9lLgjqu48rtoQqVKKBycoqwt/zZ10/Ga35HsxAH6bOKqFgNmdl9iLj6By?=
 =?us-ascii?Q?Q8q6cojqMl+BChPMpvszCRSIV5mgR8RkfJlLpBfz81LdBH4YaC7mUSQkzBnu?=
 =?us-ascii?Q?03YestQ/MiU2peU+1AEiHfVvxdRIo9+KnMhZvV6x7KKJhITP6rqBkjLRrWOc?=
 =?us-ascii?Q?KRzz1rohyuQGl2lRe5HtIykeJ2ESKYeiuRS7wTFiSPFfnnRy7SJ4yP9SALVr?=
 =?us-ascii?Q?itfJE6vIsDBl6EVYebbH2fwLyrrGf7wk1aO4EOvOCBEw29KAi75g4PcR4ZMq?=
 =?us-ascii?Q?jbA7i+7/1Fk+wlUtcQf5wFyGCFJMajmGeVfgkY4JmC59MBIfIAgFUDU/Ocxn?=
 =?us-ascii?Q?8G6PAFzEBQ9qOLbF1iIzwbTg02mrBqBGTeNy6toHcEpbYPhJE6LXCXEEIkim?=
 =?us-ascii?Q?hYWUiMCyl40OdLE3mxBZFxma1t5VYsfQptWs1cJKpc6HRACeRs6xdEYk+Myz?=
 =?us-ascii?Q?kRQm+72Q6rUeGk4XEu6q4tS+BKfTjsFIF3t8/jooCB30tJSeGg/hWhe9V1Fr?=
 =?us-ascii?Q?CivNw+Mt15gwxeZyo3lu0FIrfFE98qeJX9/d+SYUK3X6vcgTCpPlYfBksnxC?=
 =?us-ascii?Q?+gkSmTRpVrZ4BD8rkkFde0OH4glXMZK3iFexCdW17wszchlqLwaJc+FUCA2U?=
 =?us-ascii?Q?RdWfP+rMyHmoRR36r7wLIeDjUJMB?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c468c439-d990-42b9-6ffd-08d956722e77
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 11:31:05.7845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXtW8YhFbEBU0nEpNqEpxGfKVeY+HMBQ/Qaef7gNA4SaRSLtnxL3IrCH4ar00Jo3VlLcynvQ2tr8oYRF0oc3O/GF+hj6zr5nIEyXz/EVO2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4809
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 07:05:52AM -0400, Jamal Hadi Salim wrote:
> On 2021-07-22 5:19 a.m., Simon Horman wrote:
> 
> Triggered by my observation on 2/3 went back and looked at this again to
> see if we have same problem with notification on REPLACE case (I think
> we do) but here's another comment:
> 
> > +EXPORT_SYMBOL(tcf_action_offload_cmd);
> > +
> >   /* Returns numbers of initialized actions or negative error. */
> >   int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> > @@ -1514,6 +1544,9 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
> >   		return ret;
> >   	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
> > +	/* offload actions to hardware if possible */
> > +	tcf_action_offload_cmd(actions, extack);
> > +
> 
> Above seems to be unconditional whether hw update is requested or not?
> The comment says the right thing ("if possible") but the code
> should have checked some sort of skip_sw check?

Jamal, we are going around in circles.

As we have already discussed, this patchset does not add support for
skip_sw (or skip_hw) for actions.
