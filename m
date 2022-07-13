Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02315573253
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiGMJTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiGMJTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:19:38 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D5B65D40
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 02:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7l51EExKX7zn7yX5mO38bvbT33H6yeap9CwD8cFuFXk4F+R0PoZWruLXjsiUXsJDxrfkYBb3AM4jPkYMmRWx83BWgEMoh2ftiZZLmpU+mGAO/w9+rouVQlQAjLg+k/qNHJulES9/5w+gKsZrjosMgxW0QqeKVhF2apQKvkvfypthObEWurqPCQPsh7tSu06X0d4w4jms1Y0o7yhkX6QOxXNx7oMqJGdzT1fg9ihBnYo7/4ja7T5UgXkO3nPmAdRxlzS20D9iepapxq/dw3Ib4mZQls9erkmvAjHPDT1XuNdVurp/LvBKZQ+tf4nfnGj0t6VzoZJXv55V4F/b5wKVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhtVsjJvr1mt+FAEVzCyU+1pVcikUQd+0/H1IYoovTs=;
 b=k/XlSXaAqLCzqbucaxGuFhT/UJ0iZAWI5OgrppXj6cXkw5lGi0ieL5KwBo8cfzc7D/lexkTrEUeMFmPI74ACQAXPUGOqLfCu27Tku0qCrxDWNJ79UIeQKkAmxFH1q+tCbyDltZ8ZgESl5mOcV8wT0nbxHyM/Pv1GV0LKrLrTVbY5ULFBeiM7NeyBrSF1HDTyBVJ8JkuyinC8985PkPMr8K56F0+uoLxchEPKs0pb3DbLl+AiTYotP0RlE0R5OH31EJ8CmkqYCgEGgRwgWaigROrGpvIjLWU89Ek+efHmoV7nsO2BbJKxZ5FQmp9EPDYo0rmhTOBX5ArEwkxvHTKtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhtVsjJvr1mt+FAEVzCyU+1pVcikUQd+0/H1IYoovTs=;
 b=2WW7X5B44yMfeOw+JVSMNqzPdc847jM7sRPVu7qxws8meHC2m2tXL2dErVeKvMbl09HnqAp01RTTSyq72+bHCQrrkCM1zaHFl5h8XBFbphonIfb5Cs16RDEAC6ciOjbAAq4lulkdTSLerdqoC2+65zDU6cxWO1fFZVwZFfSVdmNOFcuNXkNdznVWRypEydJhSDDcT8Il47l9j0Le+xAYX/vvgulcHCQuv30AYTuQp7Ky7lri5c12POiApZxsCGh6yZZk5XdY/swiFh5h2VZ/mIvE9isP45e91TS+Itox2eJhZlgZ91RRtBDntf0ySsJvvn3MHuQy5ZxgAKEMIX3Jcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB6248.eurprd04.prod.outlook.com (2603:10a6:20b:bf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 09:19:34 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::60ad:4d78:a28a:7df4%4]) with mapi id 15.20.5417.025; Wed, 13 Jul 2022
 09:19:34 +0000
Message-ID: <16fea59d-6e61-4554-8198-24973e1300ef@suse.com>
Date:   Wed, 13 Jul 2022 11:19:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH net-next 1/2] xen-netfront: remove leftover call to
 xennet_tx_buf_gc()
Content-Language: en-US
From:   Jan Beulich <jbeulich@suse.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Cc:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <stefano@stabellini.net>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
References: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
In-Reply-To: <7fca0e44-43b5-8448-3653-249d117dc084@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::23) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cd962c2-8f36-4401-9725-08da64b0ccf5
X-MS-TrafficTypeDiagnostic: AM6PR04MB6248:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjqA5UPNKnvSDeV+Ujj1DPUF6oYp2NHFbLQvMWFwrbcyJX5nvLR4Ye2YQcod31jRrDUZtED29aGZjdUBEa7p0dqAs5bjSwpPuTBZginC8TA6axSRbu2pgGAmU2uBYaA6u2j8sSkjWhbEc+O0BFnw9bIYbjPAdlbK+d4CIaspOpUT/LYROT8jH64Yo5TTNwWABdRoGZgSxwqiWZzwXqUySOYS70ne7FzQQ8ZVCjBdbSM2ssk9bnMeNCBQ3uX5+HvkCV7qNi0D0LyFElh6xo9j5jaZEtRuRs7LfcqisFzeiGG241keI5SvcYpVNhFA9mSK3jBgFilQz8SQtmlvAELWfrlxKX+yj2Af2ILYfQ4WQ50LBxR2VGBTS+qqeaQp4Xp8ZgE6W5UwbhZnBehzayWRY3G6eyHgZQyj+dj2gFNjkmNR3pPzGoN0/qCevGSsFboLJYsi8dsh1HJ/ACyY9GACziIiTiLbzqlxBUOAAmHFhYtONEwOwqOt/8L9gyrS13/oQiPZgwiuiXyrjLxWYqft+Un5fzlmQ5RaqCZE3mqjIhsxbvZIwRQa7aI2eGMkLWRqvCBUK/muU0N2MdJv85SNQVXcf4i2PDDb4NoTzq5YdA6gfkLjrYybfIImQhRkPsV8GEJ7KXDthFdpJOb3Ooi3xOX+/tAoXp788p/7B8kUOg2Xonlltct7ct/vvYzPSpqXvqLjXOeVVCxVuRzkF+TbioOUKIN8BoQKHDUxXDoYVzttHB/84NMQZFsB5GGnpLo6TY0d3SdBO+1Kyg0wp1N+nGHEQp6XPPDpGgVjD/A8DET69D5JQ8DRRDht9jHPoD8MxtXsyFacTipgbjxEEsdMw5Mej6qNWhbul5sMamQ0+DI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(396003)(366004)(136003)(39860400002)(2906002)(4744005)(5660300002)(8936002)(83380400001)(31686004)(2616005)(38100700002)(478600001)(6486002)(86362001)(6506007)(110136005)(8676002)(54906003)(4326008)(31696002)(66476007)(316002)(186003)(66556008)(26005)(6512007)(36756003)(41300700001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGd4RGd0cU5UN2FJSVZITUo4UDF2SlVjL3JFSGRleEtpVmQ3TDBKRFhETm5k?=
 =?utf-8?B?TUpURWI5bTRiQnlsVmh6cDcrbS9zVEhpRlcyVitiVGZuK3ArMmxNZS80dm5V?=
 =?utf-8?B?Ymk4eGxHTDYyaHVWWldZeEJ6clYrVVVMd3pwc2tzRlFkR0o0MFFJZzNjcm1Q?=
 =?utf-8?B?Tk9rL3ZTdHIzeUNwUnBDNXNBdm5FR293MmhjQjl0blBNVG41eGoyV2xJcG91?=
 =?utf-8?B?M0p1Mmwyais2c0tYdVdKM0hqUGszbnhRRURhckIzM01OUDZpYXA1b2w1L25j?=
 =?utf-8?B?ejhRb2RweHl4TTVUVHVDOW9mN05YVnhYN21DRmZ0UlNNYnRmWFExS1FDc2I2?=
 =?utf-8?B?NUJqb2ZKMmhVbVk2VUhpZHM3MjJpYU85V2ZkSzVoSnpNMCs3NWhoYmFleHlR?=
 =?utf-8?B?bGp1eEYyVWQ5aHMvZ2oyZGhVWDlwNmZYYnk3dTF5bU8yU1RULzdGSmRWR3Ru?=
 =?utf-8?B?TlVCSjNzR3FtV29uTThob3hUQWIyRzZMRkQ5dGh2K1dvSHBZaHdZSDJxakpv?=
 =?utf-8?B?WjJXdmtGalJXMkpiSWN2KzRRWFc3QldkZzFhNk9ZNklYaUFkQzZuaWt4WXlS?=
 =?utf-8?B?MTdjZXl1SU5UM3hCNDJvZE5GdERZNFR6UW0rMjBCbzcwSkZ6dkpqWUh5ZTBJ?=
 =?utf-8?B?NGxBM0xIVXBmME1kU2k1VXBmWis2ejAwZmxicnpieXR2M1JMcG1xb3ZmRHRl?=
 =?utf-8?B?VnBreG1EWUJuL012WGNNZVR5RUpzNGNOWFlXWFFSRWxkSXp2eFhrbUZ5cFND?=
 =?utf-8?B?WFNwL2hhVi9tc3NoNmpBVnQ4OGJzakdOdzJodG5ZQWlKRG92WExyTENaaENQ?=
 =?utf-8?B?UHgxUU9NQzlaMlArN0hJdmlIWXNDbS91RERhUlovU1dFZDQ2NU1jS1NCZm9X?=
 =?utf-8?B?TnRRcVdXSmxiaFZSSG5LelJscHc3cDNQS3QvdVRsRVl3M2hGTFlvbzRRZmt5?=
 =?utf-8?B?UHVLbHl5emxyYXE0cGQ0ZHFzcE5ZSlFNTC9PQTFEdEpOYnAvS25pR1dQaGM1?=
 =?utf-8?B?RmgzMkNYZzJZZTRlVFBWU2o1d3RSaXg1WngwYlQ0T2NwQitkZnkyaTg2MTFt?=
 =?utf-8?B?RldMRDFHS3ZKZ1Z2WDh4ZU1QZmcrVnIrZjNrYzFDOHVRYnhxTHhBVldCRWFi?=
 =?utf-8?B?UXZCZXFtY1phQXlYV1VzQTlueG51RzIzbVI0eU5BanRVQisrZkZ6T2FYR1NY?=
 =?utf-8?B?elZrYzJaRFpyK3VBdUlSUjgwVFlGdEtPS0c5WTljYTluSUN0aFdwU01zUjhp?=
 =?utf-8?B?ZDAwZGNXM2lMZGNHZjM5ZWpic0tVVUxDcG1ZK29WQXBwV0REYmxGM250Mlpw?=
 =?utf-8?B?WU9kbEY5ajkxaVgxazNOQ09id1F1eEx0d3NXdURyYlYyMVBaVFM1YXh2UXp4?=
 =?utf-8?B?dW0yWjI5bFY4bWZ1TlRNenF1cGNiYk10VjJtZVJKazhHVlE1eGNVUTB3bktP?=
 =?utf-8?B?RjRHWE82dThWVTRPWXdnNzBUeDF1ak9wUEZyZ2EzbUN5MSszTjJZdnZiRVZs?=
 =?utf-8?B?OVZvUEJtdEFIZVdrQ0FWc2hscVJhb1dWa1JRS0wyZHpHWElJSElNVzRWOHFm?=
 =?utf-8?B?WGVYUmhPVno4RWwzZGI0YmEwV2h2bGE4SS9JdXFiOW5Ub2wrczBQR2ZlM1pO?=
 =?utf-8?B?bE92dzZGZ3AxVkxKRHpQajAwZWJuaUxteFBFWDdvNmtFb3dvOUZjdFNOd3k2?=
 =?utf-8?B?R0FINVJRZmdUQWR4TnR0L3pzbXkxVVpOelBmUWJtNnVJbHF5QUk5RzJ6NHN2?=
 =?utf-8?B?WkVCOXg2cklMSnNmQ25VQy9kUi85ZDB2K0o1UTM5d0MzdGxNVEtqdVNGdXkv?=
 =?utf-8?B?ZHVYWnQxaUlvNHRFY1FubDlkRFFyVjBrTFVPUFFrRTUya2VEVzArc1Z0UUFt?=
 =?utf-8?B?M2lyQzh0OG5TZVQ3RmtaRUw2RnREdUJrQnhjRHMwcWEzdzYySXNTdVJSWnhJ?=
 =?utf-8?B?MzdHTDhwWUZaek1wUW9jaFY0MGpvUUZtdFhwNmRjUFZJZ1FWYVRHTXlWSDlH?=
 =?utf-8?B?OUhwUElNcnpQZVlnSmFUOXNOU0tyT3RSeGhxQmxHSE1uc3dqNXliTEszbHRF?=
 =?utf-8?B?a3JjVXp2NlU1dVhnckhUNmJBU0lHbFFRQmF1ejgweVV4eEtaeGtRbCtaYjlI?=
 =?utf-8?Q?tpn2XBcTKVYvDyFj7Mdn0s6tv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd962c2-8f36-4401-9725-08da64b0ccf5
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 09:19:34.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Re99TmEfUYuJ690Vobvvi41+hlirjrAU0zWiZCqcX63JSfn/A0SNnlP6DbLkIwTYIlaUEl67GjZ9CtarnZFSSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6248
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In talk_to_netback(), called earlier from xennet_connect(), queues and
shared rings were just re-initialized, so all this function call could
result in is setting ->broken (again) right away in case any unconsumed
responses were found.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -2464,10 +2464,6 @@ static int xennet_connect(struct net_dev
 		if (queue->tx_irq != queue->rx_irq)
 			notify_remote_via_irq(queue->rx_irq);
 
-		spin_lock_irq(&queue->tx_lock);
-		xennet_tx_buf_gc(queue);
-		spin_unlock_irq(&queue->tx_lock);
-
 		spin_lock_bh(&queue->rx_lock);
 		xennet_alloc_rx_buffers(queue);
 		spin_unlock_bh(&queue->rx_lock);

