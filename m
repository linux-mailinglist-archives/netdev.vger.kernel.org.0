Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F00946A4A2
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhLFSem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:34:42 -0500
Received: from mail-dm6nam11hn2205.outbound.protection.outlook.com ([52.100.172.205]:64064
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233663AbhLFSef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:34:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/fGFwKxI6HymK96drTcjBeWCMvTVgak4P5lwwQB+i8OSaW4qil8zIQra/DaRi3sVqCacmq7plHtPGidNVNNAdiICg3Ixr3e/5SQNf+MUaFz9WlGoKW9WRevFaraizOxay0cvglg8WyU3mCLBrWXcnHAXwytFuQnM6FDqbpL3fMxMGyJ8h3rWtujNUI6bBSIPxn2CHCiRY4rKx0HBYs1OaJozibYeYt4sTJB+eOzKM7n86SK+LsJJK48VHQekxSiZqATwlnel0cyusmXqe3D+oX/zb8uQNzfnPiTke7YB0i051zTmkotkOEWLsGb9wyTeA9d2bdFtMroLmRIIYcN9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTkULZ5UHExQp4+lt+mjKcEqTWLs4cv4821EJcQtSYE=;
 b=fMl5cWTa+sLqxB0DBQiSrhMzWdQtYkfq1S7/nfO6jq/zlNtIM/HxcflNG8rdRfh2FdrDAk/SdSFjU/BLrbrrVfMsX/bQ5sOmyus7yBLM2CJchGJMKEhOnG9enPQX+h+l3FbmClkgU8vIMwaj7K1URPxCClsopsRPgLt/4jBRaZGNX/eGruU6vD0XiP7T+Cqoe+flZlH1qD+T3os3IfwhfbT11PAnETLM54uWJD1GvhfCE0eHUBxonjPScvlMTa4NRUwseiree9PM+y4v7VNNWm8ljul8DlxOh3kehs/pi7zHkESOBHbjVJFYaLjrItawpR6/eki+PkwtqLENQpIyAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 146.201.107.145) smtp.rcpttodomain=sbcglobal.net smtp.mailfrom=msn.com;
 dmarc=fail (p=none sp=quarantine pct=100) action=none header.from=msn.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fsu.onmicrosoft.com;
 s=selector2-fsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTkULZ5UHExQp4+lt+mjKcEqTWLs4cv4821EJcQtSYE=;
 b=dOK/R3alw7g/UnrTtOjPlQJKEMpZIlCe59qYVjfMf66o/Ajn13y6cWg3DdUtysiJ0uXmCT+h2idAhCA0TvLijVwHb5SrHpOXnxaZJqGQzcmQlx9Vavfhb6XXWwqZbBlpjGGQvMZMHRk1HGn/UXglRi01i7cGVr9Z4jXheTnyoXs=
Received: from BN1PR13CA0011.namprd13.prod.outlook.com (2603:10b6:408:e2::16)
 by PH0P220MB0555.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 18:30:55 +0000
Received: from BN8NAM04FT037.eop-NAM04.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::d3) by BN1PR13CA0011.outlook.office365.com
 (2603:10b6:408:e2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.10 via Frontend
 Transport; Mon, 6 Dec 2021 18:30:55 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 146.201.107.145) smtp.mailfrom=msn.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=msn.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 msn.com discourages use of 146.201.107.145 as permitted sender)
Received: from mailrelay03.its.fsu.edu (146.201.107.145) by
 BN8NAM04FT037.mail.protection.outlook.com (10.13.160.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.13 via Frontend Transport; Mon, 6 Dec 2021 18:30:55 +0000
Received: from [10.0.0.200] (ani.stat.fsu.edu [128.186.4.119])
        by mailrelay03.its.fsu.edu (Postfix) with ESMTP id D783395192;
        Mon,  6 Dec 2021 13:30:17 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re: From Fred!
To:     Recipients <fred128@msn.com>
From:   "Fred Gamba." <fred128@msn.com>
Date:   Mon, 06 Dec 2021 19:29:35 +0100
Reply-To: fred_gamba@yahoo.co.jp
Message-ID: <a1168cb8-3692-497c-bad8-4074d737e690@BN8NAM04FT037.eop-NAM04.prod.protection.outlook.com>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 285d677c-b86b-4a6c-6a06-08d9b8e68a5c
X-MS-TrafficTypeDiagnostic: PH0P220MB0555:EE_
X-Microsoft-Antispam-PRVS: <PH0P220MB05558697AC41F489A9C483B4EB6D9@PH0P220MB0555.NAMP220.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 2
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:146.201.107.145;CTRY:US;LANG:en;SCL:5;SRV:;IPV:CAL;SFV:SPM;H:mailrelay03.its.fsu.edu;PTR:mailrelay03.its.fsu.edu;CAT:OSPM;SFS:(4636009)(84050400002)(46966006)(40470700001)(6862004)(7596003)(336012)(956004)(8676002)(6200100001)(5660300002)(26005)(356005)(40460700001)(7416002)(7366002)(82310400004)(7406005)(7116003)(31696002)(6666004)(83380400001)(6266002)(35950700001)(2860700004)(86362001)(70206006)(316002)(31686004)(508600001)(3480700007)(47076005)(786003)(9686003)(8936002)(2906002)(82202003)(70586007)(480584002);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFVCRFFHUUFQRE1Mb2xNd2pYeE9kTVNGLzh4ZVl3SzcvR2FHVDE5eStNNWtM?=
 =?utf-8?B?WWtGWktyaFdoZjJzeUlTVy9wOE5GR254SUQ5WkExOE9wYUZ4c2RSd1dlV2RE?=
 =?utf-8?B?UXJNQVdPYm43NTZBaWNoVDlhUm1aNm8xSTcyZS94V0JKVlEzL3VuZy95STN2?=
 =?utf-8?B?TnVXWDBYSG5tbm14aUhtelp0UkRldFEyb3dvalRJTWk2Mm1hcS9kdDljSnBG?=
 =?utf-8?B?NGVUWG1iOWdkVStFRHpydzVyNFVJbjlRL1BsVEhXOGw0V0lEL2p2ZWtKVTlO?=
 =?utf-8?B?cXVzRFNaWnduamZINm9CclhSWW5CY09aM2RaeU51dWJ3enpvODZzbEdlWEVD?=
 =?utf-8?B?OUZWdlhGWlA3YWg0bkZ3SHpTYjdLQ0x2YWVuZjRzYnZ4ZldjTkFPbkpxeU5E?=
 =?utf-8?B?cFRkSHJBeCt0OERIelU2dWxScXFSSmpmUGVvQ2tPVktFNCtnMllOWjFVbFBI?=
 =?utf-8?B?d2M3eUliaXpEb0dwNC8weE0wV0pGWVpTWmdaUFVnRm1uRHpzbnRWcGxNdmdi?=
 =?utf-8?B?K1pqQm53ZC9Ia2dvSFRJWlR3cFMydno1RDVIbS9MVjNGWWYvYVg0YkQ1aU10?=
 =?utf-8?B?eVFhZXJEWmNoR1R0SjI3SUdEWUg1eGJDd1I5cHRYUE9nV0tCOEMxTm5DbWZm?=
 =?utf-8?B?bVlyUjdJUnlTMHQvNzNUOURkdVVwWUpCTFdzeXVLVFVEOGZMMzBtbGJEWXh3?=
 =?utf-8?B?QlZzQ3QvTHJlem5WZUNYMy93ZndoS3JpRVhQV3l0ZWs1RCtlQnREdmlUMXhB?=
 =?utf-8?B?RkRKYXpraTFkZGZmeDdVOWJyR0dIeUp3N3F2Y04xS2hjM2owc1NQR215UXNV?=
 =?utf-8?B?bCtTb0pYSzRiVzBLU2hxQ0JRdWRzaDBNRzNOTGFkYmw3MWFjaENQdFlXUjc5?=
 =?utf-8?B?WkR1cElDZXJldnpBS25RaUM5VXl4V3Z6dit2eUVoejY5R3RjS2Q4SEVyVlZ3?=
 =?utf-8?B?UzZWVERLSmZoc1NQWmtYWFd6eGdSQytwOGwxRWlUK24yTVczTERPcUJXRVA2?=
 =?utf-8?B?TFVqTFRWMXZVQkQ5ZUtBRG1kMTFxc0dpWEg4cnJsUGNWZmJaS3FoWHBHOEZK?=
 =?utf-8?B?UTZrSTdNMFRzeTFRWkpXbnpwL2tOcVB0WDdtemVrbS9GL1ZBaGtCWGJib3I4?=
 =?utf-8?B?M0dtaWNYTjFVRHp2ck52Vk1IV21mOUxYMEpac1FMb2Z5R2ZSOTJYcURzVVdZ?=
 =?utf-8?B?eGphKzFacnNOdGV1TlJURFdiRXAzTXZKK3dOenh6T051cGxMRnZRQUhnbVhq?=
 =?utf-8?B?Ry93WGJ4b2dkTytDUzlJY0w3dUNYc3kwaENPVkFNMlFrV045WVdFQVRRZ25K?=
 =?utf-8?B?MFpOVTltSEwvZDZMdUpGYjUweVZIWU5zSTVDU1BOeFlBeCs2S2lFRWRzQ0VX?=
 =?utf-8?B?L1ZiUS9KYU5NQytMVTFzRTRWN2RCZE91c0QwdzN5SUZMSFNCdXZMdmlVNUh3?=
 =?utf-8?Q?41ncvMH/?=
X-OriginatorOrg: fsu.edu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 18:30:55.1999
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 285d677c-b86b-4a6c-6a06-08d9b8e68a5c
X-MS-Exchange-CrossTenant-Id: a36450eb-db06-42a7-8d1b-026719f701e3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a36450eb-db06-42a7-8d1b-026719f701e3;Ip=[146.201.107.145];Helo=[mailrelay03.its.fsu.edu]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM04FT037.eop-NAM04.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0P220MB0555
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I decided to write you this proposal in good faith, believing that you will=
 not betray me. I have been in search of someone with the same last name of=
 our late customer and close friend of mine (Mr. Richard), heence I contact=
ed you Because both of you bear the same surname and coincidentally from th=
e same country, and I was pushed to contact you and see how best we can ass=
ist each other. Meanwhile I am Mr. Fred Gamba, a reputable banker here in A=
ccra Ghana.

On the 15 January 2009, the young millionaire (Mr. Richard) a citizen of yo=
ur country and Crude Oil dealer made a fixed deposit with my bank for 60 ca=
lendar months, valued at US $ 6,500,000.00 (Six Million, Five Hundred Thous=
and US Dollars) and The mature date for this deposit contract was on 15th o=
f January, 2015. But sadly he was among the death victims in the 03 March 2=
011, Earthquake disaster in Japan that killed over 20,000 people including =
him. Because he was in Japan on a business trip and that was how he met his=
 end.

My bank management is yet to know about his death, but I knew about it beca=
use he was my friend and I am his Account Relationship Officer, and he did =
not mention any Next of Kin / Heir when the account was opened, because he =
was not married and no children. Last week my Bank Management reminded me a=
gain requested that Mr. Richard should give instructions on what to do abou=
t his funds, if to renew the contract or not.

I know this will happen and that is why I have been looking for a means to =
handle the situation, because if my Bank Directors happens to know that he =
is dead and do not have any Heir, they will take the funds for their person=
al use, That is why I am seeking your co-operation to present you as the Ne=
xt of Kin / Heir to the account, since you bear same last name with the dec=
eased customer.

There is no risk involved; the transaction will be executed under a legitim=
ate arrangement that will protect you from any breach of law okay. So It's =
better that we claim the money, than allowing the Bank Directors to take it=
, they are rich already. I am not a greedy person, so I am suggesting we sh=
are the funds in this ratio, 50% 50, ie equal.

Let me know your mind on this and please do treat this information highly c=
onfidential.

I will review further information to you as soon as I receive your
positive response.

Have a nice day and I anticipating your communication.

With Regards,
Fred Gamba.
