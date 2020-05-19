Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889471D92ED
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgESJEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:04:38 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:54535
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726333AbgESJEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 05:04:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bYzxR9bOu1HSd7nDH1iWOEzaCxDk3xdnxA2hIPBOOqJOdLL75/B7EZbnqOPctZFIK/eXhWdVkJkcX2695F/6wMcmAuR5J4lkue0HwsmgI+wpICXppVWBlDilgAXr0w1eqC80bkzIwR/RVk/uHorOApvxlO9KuTs++SEG8bpw4coOO4w/dZyKWNVmg8Jt29UlrIaxAKvXpDZqJrFIHnPjMRho8PL32eTMP7JuBcuMHSGgAmjLlR8qZRrpvMkBoFupLaKxBGIbhq6uplMQjhrHMonZGZBtJYSp4YKYLYn84XuvBqkqAvdpfCx/EOA1r4h9pltggEK5MEBiI0dEQwg8YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgT+2JWhuBy1d+zq30fBSeA5wY8JMMm3ZEsbKQikrnI=;
 b=Iv55doD//aCR44tvKk0MqPunHkZRlSnpCZdumtLI0J9YhGMyvPM3hPEUVWLtozYZ3cfTejgvGbQVsBOx9XANa17EofENcWzrPpXqzG9DkLhcl8na+EWECcd0v0MdpPjK4EQIyVzQGqMaiI+bTOn6v4pcAdXT8Dmbf5M4AB49tnrfJKMwLkuQAv5R6+GghrWXsWM+5u37tVOwc9w862CVojXmmHvcqxVnp+eHiTthZ01fE7Mt8tLQlYh3OIoBmTiFZ35zbeLXfXijFog4SRvH90jL1OmxRIkHmqrCMb5GhbTGFwaJ+WzOjSXkJp/vebyyh5RWPLFGtcpyApso8mOH6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgT+2JWhuBy1d+zq30fBSeA5wY8JMMm3ZEsbKQikrnI=;
 b=SjZur2E38eth8hSQLWviWVSCftZ+nO4R5axnrJ54pGcHimR+E72bLKadEqleqU7+6snKQ+OTauuF0+nAPpbcWdkArkG1caromxXG9+fsEYNx/I9AujOMUQY9Y81KtH1aTn1qp4/dePsJi/3aM2pZzjKM06rBJbX0MJgJoQGA3GU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6868.eurprd05.prod.outlook.com (2603:10a6:20b:1af::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Tue, 19 May
 2020 09:04:33 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 09:04:33 +0000
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
In-reply-to: <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
Date:   Tue, 19 May 2020 12:04:30 +0300
Message-ID: <vbfo8qkb8ip.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0032.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::19) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by FR2P281CA0032.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Tue, 19 May 2020 09:04:32 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f10afff-766f-4096-2891-08d7fbd3a5ee
X-MS-TrafficTypeDiagnostic: AM7PR05MB6868:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB686818D4F3AA93C84128B43CADB90@AM7PR05MB6868.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rFN54d2nbpNdQy6ap7DpEVXAuvrQcqy/2GQX5sL5kWDgNYziVXXXOiH0vqVvSG2vI7NLZKkcJsryvfFc7CMrGzG9O3OpC3fTpnoo8Yif+HRwEa4Kxve0iIQ4SvnpZ4NOCa0L7vF3EMLaAHzBMbomnagGQlGWijKDR62wiRL0g4N/09NEnso+BhJvVF2bF+9nlFkNvQjZNwx6j9Nd0E6yG1kX0R6ZRLIf9C6xBxOGfGHSqfXkEf0JCoiMFyJWOLzuCHJLXMi6BALRtMnKxGj0M3ZjP4Fq5Mc7t53belLY6KuGEte517QpMailt9DFZ450vKlQQajA2phk0q5OeHgEb25mZZ4faMDeUKEGygptRLkitlHpEIAoduMDx2FVnNooRZ/+CvukcAb6ZRQNeENZ90qGEpJPfGT43TzchUASteau9AGDPSl56NJjvx9Nat/t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(5660300002)(53546011)(6916009)(316002)(7696005)(36756003)(52116002)(8936002)(4326008)(8676002)(478600001)(26005)(186003)(66556008)(86362001)(2906002)(6486002)(16526019)(2616005)(66476007)(66946007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zpyyGn6kLw4lrM8HFpChJPvvVlLO74nNccsBZMVJUzSZv2AEF+YTXe58bGbmXuLSoapmR7Zk/Y4sN5c9OC2CLHkYxWRaOkafZ9CEwI/5kKPp0gJzyqSJ5lPNvDCkbA56LPr3NpofPDMF16KmWn5HEZCgxBMK2DeUwWoUyizA6cO2/98Bosp5JzUzOe+op537rjdIOFwKcm1o8FMdx9vtrS6DODWmG+CM8FOu+FQGU1VyVp9BY1Y1YfJWkE6QE7T0n+x2rSWERE+f3oXngzG2j+y/9b0xgJSGlKdKSdGUhXBWdL1/uZuf8SaGLq16/bSLDXXkQcBd3H4jet5fTF7ZBYUf7mhS1cQB6vNS2E+BcmGnx+uXJPAY2Nbsu6Y1efDNCAR0tIjB3mBIl+0GrBFT4W9CtLdCAzCBTb0rnUeu/i760Zp/6h33vvfmvG+C8VwiRS6+E5ugwQgnqKGPQ90sTUIIEroWayCTL0WXs745r7k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f10afff-766f-4096-2891-08d7fbd3a5ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 09:04:33.8426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTe+oPhXgCJQfZwd27GQxPb5H2xT73WwvCe2pYNZVhGOFrzZlWN/87biVQkCW5+K/m7xDvjUWB+D5p1WlAGmZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6868
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 18 May 2020 at 18:37, Edward Cree <ecree@solarflare.com> wrote:
> On 15/05/2020 12:40, Vlad Buslov wrote:
>> In order to
>> significantly improve filter dump rate this patch sets implement new
>> mode of TC filter dump operation named "terse dump" mode. In this mode
>> only parameters necessary to identify the filter (handle, action cookie,
>> etc.) and data that can change during filter lifecycle (filter flags,
>> action stats, etc.) are preserved in dump output while everything else
>> is omitted.
> I realise I'm a bit late, but isn't this the kind of policy that shouldn't
>  be hard-coded in the kernel?  I.e. if next year it turns out that some
>  user needs one parameter that's been omitted here, but not the whole dump,
>  are they going to want to add another mode to the uapi?

Why not just extend terse dump? I won't break user land unless you are
removing something from it.

> Should this not instead have been done as a set of flags to specify which
>  pieces of information the caller wanted in the dump, rather than a mode
>  flag selecting a pre-defined set?
>
> -ed

I considered that approach initially but decided against it for
following reasons:

- Generic data is covered by current terse dump implementation.
  Everything else will be act or cls specific which would result long
  list of flag values like: TCA_DUMP_FLOWER_KEY_ETH_DST,
  TCA_DUMP_FLOWER_KEY_ETH_DST, TCA_DUMP_FLOWER_KEY_VLAN_ID, ...,
  TCA_DUMP_TUNNEL_KEY_ENC_KEY_ID, TCA_DUMP_TUNNEL_KEY_ENC_TOS. All of
  these would require a lot of dedicated logic in act and cls dump
  callbacks. Also, it would be quite a challenge to test all possible
  combinations.

- It is hard to come up with proper validation for such implementation.
  In case of terse dump I just return an error if classifier doesn't
  implement the callback (and since current implementation only outputs
  generic action info, it doesn't even require support from
  action-specific dump callbacks). But, for example, how do we validate
  a case where user sets some flower and tunnel_key act dump flags from
  previous paragraph, but Qdisc contains some other classifier? Or
  flower classifier points to other types of actions? Or when flower
  classifier has and tunnel_key actions but also mirred? Should the
  implementation return an error on encountering any classifier or
  action that doesn't have any flags set for its type or just print all
  data like regular dump? What if user asks to dump some specific option
  that wasn't set for particular filter of action instance?

Overall, the more I think about such implementation the more it looks
like a mess to me.
