Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05839D60F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 09:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFGHfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 03:35:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:20276 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230200AbhFGHfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 03:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623051194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=18sc27qt2MdAUPAfqSvsq6VWZxZ7AlczriAkSGpC5ng=;
        b=Pyix9SHANTciYU2xqifUQmsV1pPfamOBPjkhWpad5Ne4T76j3sh/lOjXpOmJ1rLifMtrak
        mlO8qHY0hoOFBAesfuTQkCbBAqBXEspUI3dEcjP+q2jngRmwVDfrDCZNdD1ih0buF6aMm1
        6At6s6H3Q7AEhg63ZsWigpc5ZL5vQM4=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-Ay9mnpsqPUCWs1ZkDMNT7g-1; Mon, 07 Jun 2021 09:33:12 +0200
X-MC-Unique: Ay9mnpsqPUCWs1ZkDMNT7g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+gcBiY7SsoqJjr/ZfbF51TqIsqqrnrc0FOnqqduULWuQQ41x5/YfiyAFNEaSUIB3TcFUPhESBu7zfPtb8DxPUpJOJmxSca7PmxLZC2rNWCMdAGfG+1v6U3ymUafvhPLX8Rt/gu0QqhXYObiOd5/3i77FT6fU3rINZupXMRPoM37AFaJVtU40UCBJh8F6OhQECVL3bB5UEf7yLLa9FTtR2SAoO2VNjDYEq8oKuARWEy81ylvFIyzUpZdOA8dVIKc4BhDLtHmPAOyfCrFSB0p3HcCaeHNluIgXucAKufsxLhXpWuKEmQTiCCkO/mwhXViI4rGBOf3VBFzQKAw9MsAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18sc27qt2MdAUPAfqSvsq6VWZxZ7AlczriAkSGpC5ng=;
 b=cNVXG2a+26AtCDTMnZzlgU5yoiBDkdSm6uGCZul2+aXnkq4ejYTlpRe+g2Hr7RMG2uRQ+ygsvmfQWSzI7GkUxGIB1ruLbM/rNtbW5xlV6ERJSQfYts11+vJHdT502I1utjrmMlmZ4PRQjfcAOAKUSwQx3FIbj/AjEDByLMKgWAKMJ4AtqhYJWb3Nxv+/B64EXEjAynPBKiIGiCuegL7Pqgj+HAZVLok2lpsB2gpwUZW9qvQSupX+GiWxfBVS2ts8JEl0dw7Q7KDJBAxE6CCGbiZJAhC9SpXtmyX8/DPeFI/sfiqV0kB7/8Yq4HrjEYtww4BmVOabkOc28K4rxxldxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB6PR0401MB2294.eurprd04.prod.outlook.com (2603:10a6:4:46::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Mon, 7 Jun
 2021 07:33:10 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::790f:c865:4660:1565%7]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 07:33:10 +0000
Date:   Mon, 7 Jun 2021 15:33:02 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Nitesh Lal <nilal@redhat.com>
Subject: [RFC] genirq: Add effective CPU index retrieving interface
Message-ID: <YL3LrgAzMNI2hp5i@syu-laptop>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Originating-IP: [39.12.96.182]
X-ClientProxiedBy: FR0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::18) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (39.12.96.182) by FR0P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.11 via Frontend Transport; Mon, 7 Jun 2021 07:33:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9363e986-da74-4521-8516-08d929868037
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2294:
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2294D41DA9F2DAE97FBEC246BF389@DB6PR0401MB2294.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /hWMOC0ayEFV3Yp015C9yYeL5E4Mz3p9/G+/jemCI3ioXpLIRDHmwu8VO6Nat8RViafYMUlmqi9Tr/UmvKeP6cUoozTzx12GitWtt7fDVCeUr6jDj4HD9Z4VaksmaJgk9sdlCHGYAcShORzlNsE2vNGDoGAIfHn/bppp8SkKs37vcX9KJpStbel7JKuZTQt8xmEFNb/uT744HYZdY8HlNSQ6v1baiTWfPrTv0NGXUageGR5ucReNMcl0ECKqW99+ZXXM8PbFGnQsnifhYjuvIocDgHL1ptwxTH1dm5u7E431YOKwEDzFrC47ziZEzb9PeSoG6SM3pvOWLgPW0Rw7ZxtTAWtku/xXrHmGcIzlikxBQm1nLZM9oYyYXH/0ufTDAsGxucJkMlxeNY63MubQrvjFeVQduJYZFpy28I6Q8Zrzi6OYObz5/yz+z97GvhVANKe0MoQ3M71K0qYh/G0TJC3WInpmMGw+YcAKeVr0gUrWYK4KGFvSTWiRU8S80lMWEkhDIIVhw7kTTpq+TJ4RL1C+0Rm04ih3RBjwRyLJZumhf04RDZruJS8QTb36njf41wEhqCtBPVc7zjQrETp0BnWks2XGwxjRrHGCVw8615jPnQxV16bOvwXI+HjLidwhlXeUdfj6wxRGfkso9JA6hsvcca7L835n024FVWMEchyo/Qn7UHokl0Ixuiuj4E4ms314bUCDiERMF0mBWmYm2k+3NzKRzArzMy8+vNRgQk/BVCD/1j2/WyFMYJ4plZr5O+AN3+H97gYVTOvx2NloJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39850400004)(366004)(136003)(376002)(33716001)(83380400001)(8936002)(316002)(478600001)(6496006)(966005)(86362001)(4326008)(186003)(16526019)(8676002)(26005)(66946007)(6666004)(66556008)(2906002)(5660300002)(55016002)(9686003)(956004)(38100700002)(66476007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGVjVlQxcUl1QmRtUWd6aGZObytBU3djaWUzcS8yazZLTEFCN0haOWFiQ2dt?=
 =?utf-8?B?Z3ZOMXFHZEhqSTFCOWF3SHl1MGxWVU9mdjdrb0FvV1paQW1acU9LeThzMHF3?=
 =?utf-8?B?UmdFMXZuRHZOVDlSeUg0Wm4vODZEZEVLMm5NWGR0Qy92NmxqUXpCdFltdnhz?=
 =?utf-8?B?aGNLV0lOKzBVSFhXQzduZ0oweWRtTlhvRytDZGQwdG9ZdVNTL3BtU0g3b0E3?=
 =?utf-8?B?ZUpHOUxuT0k2WllpaWtReFdDcFIvL0xNZWdaQkJ0NEVYQXhoVE1Qck9tcGN3?=
 =?utf-8?B?OEZKNHc0VVJIaEFyb1l3WTVLdlBtQWxaUUJld0xvL0kwRUVBUUV3akRJdWVz?=
 =?utf-8?B?THY0YktudFFCcW5PQW9sWksrWVhXbDBGczVGM1U0eXRuaS80SnI1bEx6SjA1?=
 =?utf-8?B?MWgwaG53ZE5obFlLWmpRc2FqUnJGd1ZCcmhCc3A2TkdPQ2RaQ0FCejFsTXZK?=
 =?utf-8?B?aUhXanZUM1ZxNHVVNXQvU1M2elpJNTFicXFXRlp2YWJXZ0ZCcklNajcra1g5?=
 =?utf-8?B?WDNhNzN0QnVvc1VhRGNkZlBpYTlrNDVHM1VHdjJXcWx1cS9tL0NLVDNBditB?=
 =?utf-8?B?Q25rT1NERVFSaVNOQnc2UHZ2ckFHZnc4ZVhHWkR1UDMvK01Kc2RBODBSOXlF?=
 =?utf-8?B?SVV2SWdqblBBcXpxeG0vMmNlR2Y2ZzRLanZyRmg4aTVnYXZ6WW80ZXJSOVA5?=
 =?utf-8?B?b0hDT3lTbTlpQlBkbzcrQkIrYitUNlJFSHlRU21Idk5TQVZEZUsxbVRsdnVx?=
 =?utf-8?B?Ym42Wmt5S0RQUEY4SWVTMXZwSmZPTlZkRUM4OENCYUc2QUpPUFJBczNpSXZ3?=
 =?utf-8?B?UGthODdjeitLU1kwNXE1aVF3OUQyaGR2by9WUStQNUdlbE4xRGpFcFVGaGRJ?=
 =?utf-8?B?MkFyRzVHUyt5QmJDV1JuQzVucGE3NSt4MTh0cTBuL205V1UvenVjNXVKNitj?=
 =?utf-8?B?TFpPaUtISHJmRTRMUmtReXBwV0JSc2xrSTg4cUMwdFZwN3UvV1ZGbFJ6K096?=
 =?utf-8?B?Mlk4Mi9GOTRUMU9nN1h6V1Y3N0JMbXcvOHlSSzZZdWVIQS9BNmpoQWlZeFJF?=
 =?utf-8?B?aHVTNi9pcVRSalV1V3hiSWcxMHBLV2ZuakRSWlNUN1NnaWZqdEd0aVdyVG53?=
 =?utf-8?B?R0xDNTlBVEExV3h3TmVuRTloZTE0YlBra3F6QTJGeDlHTVNrR1dJYWlUTnA1?=
 =?utf-8?B?STRKT2VzOExOVnpmbzh6cWlid0JIN0pBam5QTS8wR2JJS0VGV204dWY0TzJu?=
 =?utf-8?B?WGRpRXZYOUlhMUxQdDVoL252MFA2MXFuaUo2WXVMYlNJV3ovb1U1NFEraVMz?=
 =?utf-8?B?Ylh6LzI0QjFTRUhsRTVEeU5idHg1Qk1Kdk5jM0R5WkxUOVRaemNmQUU0NlFT?=
 =?utf-8?B?Ulp2UlhEMmtNL2sxYkNMbEYvOXJJK0NKUUtVQkdkcGlSYWRxamptVWhvZVY2?=
 =?utf-8?B?Szd2TXBCRzk1d0MwRW1ONTJGMkRRYUc1VHJjNFJXNVFraEVodFdjWlBZUXJM?=
 =?utf-8?B?bGpOclAxZHdKT0VZVGhObWZ5ZW80V0NZODV6dWlNY1dOeC9KaFF3bGpSclZv?=
 =?utf-8?B?SW1tdjhtSkhOQldQaCtka3g5S1hlcDNUckVTSmtUMjFmaERocEhTenRRLzVl?=
 =?utf-8?B?TEYvaWdiRHdFU2I2akszUTdyVFN3bzRkZmtjL21xZk03bnpVeU54QmlWblM1?=
 =?utf-8?B?Z1ZHdE12SDJmaDJCbmN6QWQ3VlNncWVyOVYveURzTzhPMDJOZXdUenNRQWlO?=
 =?utf-8?Q?N+Ad4xNRKkW6jILRlIuGpdP1+pLHMbSHGR0M1IY?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9363e986-da74-4521-8516-08d929868037
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 07:33:10.4123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ffQbu9I3AUFE8o8SJr15s0AfXZnjxpspbOP2Od69gedguz3mfPfFqXi1/9YhdlizBv0LTtSbsUxTt9U29g+RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most driver's IRQ spreading scheme is naive compared to the IRQ spreading
scheme introduced since IRQ subsystem rework, so it better to rely
request_irq() to spread IRQ out.

However, drivers that care about performance enough also tends to try
allocating memory on the same NUMA node on which the IRQ handler will run.
For such driver to rely on request_irq() for IRQ spreading, we also need to
provide an interface to retrieve the CPU index after calling request_irq().

This should be the last missing piece of puzzle that allows removal of
calls to irq_set_affinity_hint() that were actually intended to spread out
IRQ.

Link: https://lore.kernel.org/lkml/CAFki+Lm0W_brLu31epqD3gAV+WNKOJfVDfX2M8ZM__aj3nv9uA@mail.gmail.com/
Link: https://lore.kernel.org/linux-api/87zgwo9u79.ffs@nanos.tec.linutronix.de/
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
---

I've ask previously in another thread[1], but there doesn't seem to be one,
so hence this patch.

I apologize if there's anything glaringly wrong, it's my 1st time trying to
send a patch that deals with driver interface. Just let me know, and I'll
get it fixed.

Also, there's probably better a name for the interface but I can't think of
one.

1: https://lore.kernel.org/r/YK9yxQoBPeUfQG05@syu-laptop

---
 include/linux/interrupt.h |  1 +
 kernel/irq/manage.c       | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 2ed65b01c961..b67621ccde35 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -324,6 +324,7 @@ extern cpumask_var_t irq_default_affinity;
 
 extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask);
+extern int irq_get_effective_cpu(unsigned int irq);
 
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ef30b4762947..5e2a722c5d93 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -487,6 +487,23 @@ int irq_force_affinity(unsigned int irq, const struct cpumask *cpumask)
 }
 EXPORT_SYMBOL_GPL(irq_force_affinity);
 
+/**
+ * irq_get_effective_cpu - Retrieve the effective CPU index
+ * @irq:	Target interrupt to retrieve effective CPU index
+ *
+ * When the effective affinity cpumask has multiple CPU toggled, it just
+ * returns the first CPU in the cpumask.
+ */
+int irq_get_effective_cpu(unsigned int irq)
+{
+	struct irq_data *data = irq_get_irq_data(irq);
+	struct cpumask *m;
+
+	m = irq_data_get_effective_affinity_mask(data);
+	return cpumask_first(m);
+}
+EXPORT_SYMBOL_GPL(irq_get_effective_cpu);
+
 int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 {
 	unsigned long flags;
-- 
2.31.1

