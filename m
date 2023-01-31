Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85517682AC4
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjAaKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjAaKqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:46:15 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6774514E91;
        Tue, 31 Jan 2023 02:46:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0ALfhAfq8vz6Epb+m7zeW2JLJU3wHWpHuqfG3QVZR7MY9seLJRHxe3uX6lg9RlErkPFXyqyl3ravJE9tsdwYiLKh52DqQhpOBorh11+pyuanzQs5QlGly2T6X3y+xUxvHZ4SEgnoYqu8r9neSgZSl/JEUkbqfK8XbUF36hqL6aJwfOpNs1Bf/0CXHEre6sheLwjnT8kgkxyLJ/mg1XF0+hDs60yTlzTF+J9YQ8Y3QRyn7ZThvlxnN0zz1c1Jo3NW5ghj18pQyIIxNCuEgTLztFzaWXzlaM4F3q5iWsppWDowCrLpBvGRFEaV3/X1im1Gf2NqSQ2Wu+LTJEdDcPVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgX5BGnyX0eryyMfmFWwI1tvHdBCIGnTQAYelzNmzuM=;
 b=dPogz60BowY6UE5Z1qNDmgrbQdEq1w6bfnXxcU94VCqtjP8j6hzSrbIiEYEVYmEWEmb3szPAYo6GT8RdI6peRjF/5gL+N9f58x/DSwYioYTQtdcDB0fEKU87V2MJq1H3Cm25yyalVNlnH4bvEp7eBM4tKO/fuvUBmV+kL0kWnKYKkroM9zvAb5SduTGX7ik40KUWUK5XE4z/Z8iY3/Npv7p4QxgUFZ9IuRkEfVaT1WEoq/GLdPOfDhY/mO6QLw5PMSZ4OlpQeoYN1dUhs81+Ru/gTolVzBzZA/aodvrgbSoccDyPb2KnO+gqdFsarzrAUGiSqG8o9rKP72q6XA40FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgX5BGnyX0eryyMfmFWwI1tvHdBCIGnTQAYelzNmzuM=;
 b=n3HvhAM3tAMDFeKV8opVvZLa/IQduW0GMVz/q8SaAe4zWR9FOQnwq9D3AhR3ZRp7aKFnKqYkmFxr6Kow+jhHdm/QoZFY6MY4duabSOHZzgdCfl9Fm+k6XpKNsVtrxueY101GFP9GUyWwHVEBG29T4NChPQXBBz1D+uNaF7u49nU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DS7PR11MB6038.namprd11.prod.outlook.com (2603:10b6:8:75::8) by
 DS7PR11MB7739.namprd11.prod.outlook.com (2603:10b6:8:e0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.36; Tue, 31 Jan 2023 10:46:10 +0000
Received: from DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119]) by DS7PR11MB6038.namprd11.prod.outlook.com
 ([fe80::f9de:a81f:1140:d119%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 10:46:10 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org,
        Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Marek Vasut <marex@denx.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        netdev@vger.kernel.org, Angus Ainslie <angus@akkea.ca>,
        ganapathi.kondraju@silabs.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        narasimha.anumolu@silabs.com, amol.hanwate@silabs.com,
        shivanadam.gude@silabs.com, srinivas.chappidi@silabs.com
Subject: Re: [PATCH] wifi: rsi: Adding new driver Maintainers
Date:   Tue, 31 Jan 2023 11:46:01 +0100
Message-ID: <4019668.anssfa2V6d@pc-42>
Organization: Silicon Labs
In-Reply-To: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
References: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: MR1P264CA0170.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:55::18) To DS7PR11MB6038.namprd11.prod.outlook.com
 (2603:10b6:8:75::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB6038:EE_|DS7PR11MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 281c8b2a-7546-4381-c4aa-08db03785d94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZAlQnWOHSF5jh+GiM9Av1kBRK++F5VSpocBfbcrVxZY3K+UAgf0zAtAHQ2SrygfC08sf+nTAZtEmQl2/njJSIyzMndddDqu2L5A/u2TaYwYIVqtcXEpYP0raPTrsHE375nSwvzTDiibJBYGnmyrUwRdOttDqz79pyVKiFE9RTOOtJmb0mGULciUNnXLBUxJpwUHVoD6GA8JphMHTqKMQDZbUZSlwA4iEw7LM2gOL0lEgSRhY2fyByHcWBRp9ABbDufmqryXXIuq9iM6w+87QAmvvWjoO8LKSCpCIMzMfk6uNRhqE5R2eZHQJDLaH8nX95656aADDVl6I3avx1GJaBuw6Qx+PMZC+wj8QenTvqf2r30o476sD55b0I6dLXatytMfVr+ge7I8zqah4A+c9JpxMYzzTe4KNpD0xlsTOL8dZEjay9Re7Xou/L8/RxtMntz9kcM8ed2TskYrqwlI42WB/y+3g1vTYbWauP8QsrMnuzkmX8TNsPx6Kh56lfkPG+uMbExbeT5staPloIdNtYTJSU715s0bGCAcEMoofUL8+2FB3mjLj/SVH1tdcf3aG5EC2N8A69dQaVrxbVEcmOtl46yfPKqAXZbG5vy6C3uLv4+2x+1tIRKyIk9gTbv2rPqRSD3ENF1S9yOTnnav8vOtsIQZu371HsrXnlaZS1qnZJ+aRhOXgIbqxUm0/wizFBB/rU7r3hIAZgdu7RvwMkKq6zmFLBoP8OMXHbR9d3V4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB6038.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(376002)(39850400004)(136003)(396003)(451199018)(4744005)(5660300002)(7416002)(38350700002)(38100700002)(2906002)(33716001)(36916002)(478600001)(52116002)(6486002)(6512007)(6506007)(26005)(186003)(9686003)(86362001)(83380400001)(54906003)(6636002)(107886003)(8676002)(66556008)(4326008)(6666004)(66946007)(66476007)(66574015)(41300700001)(8936002)(316002)(6862004)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?oSJd1xahWggqVZ6doqhf+K4okAZNwFXAlknrxpZsbS4pkGHXgiSnXuetHa?=
 =?iso-8859-1?Q?hUGVPdQpDwA5cDgwYUA7c05DatQ4TT2l4piV/hPQFyctpa3pnfemj8Jx4y?=
 =?iso-8859-1?Q?Dh5ORX5OTJHnYXiABHum8sZCr1VMrfzDLxjmzKVa4iT0Z9PrY1TFO9yvy1?=
 =?iso-8859-1?Q?FL3p3LAFoVnS67fsC4Uctny1FVqjQ+Fk9fB1RU2ogPH+vFEro0Iz7BeOrv?=
 =?iso-8859-1?Q?kCWeSy2KYcg7qqWv/vO4MV2UjWB3mwjuokOUY8qXOb6zxzmGEIhr4VH9Rf?=
 =?iso-8859-1?Q?CjKeesG8ShAQeRDlKrTKrR+jSgy3K38KKsN6LTclbuHOUFTDOUe3LOFnBY?=
 =?iso-8859-1?Q?imIUomXJZAv7oz+P31QZQSV/wxUUWqqvGpNwm/q7ymkLpSo5WY6AB8hUEp?=
 =?iso-8859-1?Q?6tR8ngyQg93tz25NoUWn49FjE3uY5TT0AOabLi9uia+slD3eVdt9btIbJ+?=
 =?iso-8859-1?Q?ciyQMqRiYDrJN0XKsIX9v0CSYVAg9cwnooGOcsfPicLulXNCHU/Ij17vq5?=
 =?iso-8859-1?Q?b2vArStUzutPgf70P3gqrvk5eR8IZUlhRKWK51eRiluXYbBVpci9++VrTo?=
 =?iso-8859-1?Q?A4OOCrcdmY7RGpkpKkzAg60XykE/Yb2cAZcdGTLFSKbgEHHf0EBlWkPkUP?=
 =?iso-8859-1?Q?kJr8Un6QRJy306gmVD5Rf4Npqxbhuq0rJx7bJjLkWRYB3DbmEWbwqqTlY3?=
 =?iso-8859-1?Q?vpBw96AhYYYwyeV4w3RGRweTXCf1RoKSHjo6qe2BIkBK2lCBg7TBaPQj5W?=
 =?iso-8859-1?Q?1zjJ3y0l3uoYruFCzDinQNuaPBbc7i50zv0JFGTE7EhG9/I/mlX19pq/1n?=
 =?iso-8859-1?Q?1l7mwLvjOQw/zwiHf/RarmWJIyeZmRHXNDGRDlOmiv33CzaDfvpwJMmBwz?=
 =?iso-8859-1?Q?g0hVajjkeV0V9dbufi768nl2XC55HyLLs7W1H4COLVC6vph6bPOyznoVSx?=
 =?iso-8859-1?Q?M54ZaSuTanOGJPZslOCatlP4mOcc4oacZxS4gq6KecBU2nR6gqERiFIt41?=
 =?iso-8859-1?Q?+BJw/e8hNV5KjejgvigYIbZwxFGnYtwwTBTY+oqL0VNmgIwvZE9y2UCi5/?=
 =?iso-8859-1?Q?2Xpa7WkstNY1iSfJ18K3uzW6uWxTAUaIhWzHsfhWfDM3VVu4V/Mm77lzy2?=
 =?iso-8859-1?Q?1X2e4VJ09LiE5R+rPvjv0PQdLzqDGXGs0hax/kFQqA7Cavj1UJkENSIHk5?=
 =?iso-8859-1?Q?QHUfZufxJSjT8lonatdkvZ9tMGswdkB6+06y5L/f/6ax3D7eC6wF5ZYo7U?=
 =?iso-8859-1?Q?a3fI6ArboXgOMZUFdPpb+7SK6N8NFZ5jcjzJf2N/18nv+017NVte2fUaWD?=
 =?iso-8859-1?Q?vdK7HYPdT/ij6NkXhGWtPhffiM0Ahh5YelHcPWlBwwBXRGGqMTJdD8t9Bn?=
 =?iso-8859-1?Q?dA0Tmz2jRcNOeFaseJCk7/WNV5eTpRDZbhRfwWXwz4hXTxipfas36PEZeW?=
 =?iso-8859-1?Q?a87SFcMv2Nu2s2ZYGLCKGa0jJ3ELPD2rj/qHsYBHmqoUwNpGqs32Os+MI4?=
 =?iso-8859-1?Q?UWB7aiCz+i5IZd/K/J326ei3ZOSSDiJgr5MAfBaqFaeRYCwDV3rs4Z41Ee?=
 =?iso-8859-1?Q?3H+Z48FHQt7L4zrKh8LjJ/j1SlCz9mF0cDNeCl30pH+QUrVbb9aScNMX3J?=
 =?iso-8859-1?Q?Vpv4YshHbNQMUvX7mv7i4DVqIeIa+7GXKI?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 281c8b2a-7546-4381-c4aa-08db03785d94
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB6038.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 10:46:10.6858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHzL93Qu4XokTihycszxQPgBik9gA1L/W4NFeJj9IaJk4JSI8z3hXQCCKdYHcQJNbuFUO7sO9DBnACphKPJ2+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7739
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 30 January 2023 10:39:51 CET Ganapathi Kondraju wrote:
> Silicon Labs acquired Redpine Signals recently. It needs to continue
> giving support to the existing REDPINE WIRELESS DRIVER. Added new
> Maintainers for it.
>=20
> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> ---
>  MAINTAINERS | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20

Nitpick: usually, the subject of patches changing the MAINTAINERS
file is prefixed by "MAINTAINERS:".

--=20
J=E9r=F4me Pouiller


