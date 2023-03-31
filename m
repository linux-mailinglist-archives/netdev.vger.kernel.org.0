Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E146D1757
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCaGZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCaGZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:25:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2125.outbound.protection.outlook.com [40.107.21.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EC6CC32;
        Thu, 30 Mar 2023 23:25:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5F8v9+DvEBHnZ0u1ryQfJKd3OCpQaVN2MM5RYl6YBaZxNZV4f8b8jQqJXIvkQCLJyobV92P8YWalG+WXo+Y3sOSIoPdfEv5rBWkJ2p6mZYz8r0TlOwfiVtql+dr8uU48WJAlcK782P8TiSViasbfrffY+TSj480V8nI8O0fssHD2zUYyg0i6YgnWkP5DrxDi2q7OtlL2uyNUWy5cQXBaNzKAwuFxJYukWA8qyHTaw7Iio/9Jn5s1nqXT+7XrPtfTT465arOQkb85ZbYV4J5JeyyjvQPw/jY+gbyo1NOMdoJYeKsbuuSk6m96AumNZ0T2jfsU+ahv2Y/sm/39TVtPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xg5r3yHWRubkPfWaK6PXnC3fPcA+H42WR2b+GMWuL0E=;
 b=i6bw5374qOHBixCpCvE0O3IK86b5tEflXxogSDJMiNe6TKbcpaz74D794LhJqeljgy6ZujqEi47P6ovTnk9lY/WyKMEFSpNMdPQqK5RgkZ/HKX+25b6CBZqsBbUatbtKzqYl084+SMOzH4C5sbJTQpyNoj0isfc2S4dPlKqVsjGvgBSlSxnL5wY9xm2pcpkhqLmdOtd++RNWTE1trMD4XXJ5JQNI/6TLyhh12N8bYhBKJVo7e7h+GOGqffKqkYxidzggta0U24nuud55T5n3ow25LSp/ikmX9mh3D922/nXVqk+4KgKDtnNvzfkUKUWonKHgT4XMwqmukTQtbxSAgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.schwarz; dmarc=pass action=none header.from=mail.schwarz;
 dkim=pass header.d=mail.schwarz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.schwarz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xg5r3yHWRubkPfWaK6PXnC3fPcA+H42WR2b+GMWuL0E=;
 b=fucUAivlhr8jLKLspF2lHEiEGun46gG/aK+dU2ZsUZRIB0jyhHRkmPEs2Htcqg9/vrBjZ04FxoTcovKxoQBj8M7Wlg2SSA42PbjQmAagjDen5H7GG1gRSe7WHuFBOnjf5mCD9tgGuj0E638zwJx4rKzujzfJbGs4rjG4Vk5kRzBIc2/yhEFNvm7nqNF66eR+ecvMmNlvtj6cagSnj7GUf5Q4h+kYgXnta4nouljfrAFE0ixVcO+YXhuXlf9bjBv+suTIIRJq6RdFqwPX8Vvt9J0GZSAfJGaU9OKF0LWzG1GALavb09VAzfrSWk54jea+SR5JE4okX3OnmswEWZDX8A==
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34c::22)
 by PAVPR10MB7009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:306::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.13; Fri, 31 Mar
 2023 06:25:13 +0000
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c]) by DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c%4]) with mapi id 15.20.6277.013; Fri, 31 Mar 2023
 06:25:13 +0000
From:   =?iso-8859-1?Q?Felix_H=FCttner?= <felix.huettner@mail.schwarz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: [PATCH] net: openvswitch: fix race on port output
Thread-Topic: [PATCH] net: openvswitch: fix race on port output
Thread-Index: AdljmWv5YS2k+yAfSXWo9bXiCkDODg==
Date:   Fri, 31 Mar 2023 06:25:13 +0000
Message-ID: <DU0PR10MB5244A38E7712028763169A93EA8F9@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.schwarz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB5244:EE_|PAVPR10MB7009:EE_
x-ms-office365-filtering-correlation-id: e1e82129-ece5-4f03-5f60-08db31b0afc1
x-mp-schwarz-dsgvo2: 1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0GoQTfT7MH9J40h94HUhWiq508AlhOlunl5XckCzsyJMfrYEuiY5FDZjeG/MotpDkDvXyIZ56Aju1xJBI5/89vsHUwOpW0cZ5BqMdpUs1t3unJBsI1XG4t5xE1ZKj0ed0srrLAmNTWFHyqme+S/r9yUxGMWjmsCVyd/X0TNur6gmtI81jMTLeF8pt4E7lTm0xbpJZ1Mdm9fIRzRy3ed6lswivc1lZ5UvujW1PR1Jaakl5S84Eglryq//81QqDhRzNwAGFqfxzUcNMEH9a2KHPsctj6bYuCCfGu7znyhWcrFjsr24tb0iYQuWjT1F3jRD6MAqsTRcp379ItxpNHj63K7zqsDeE1y7aOYnSHNRPDkkqOY1c2/zP6MoFQd/3VxM8fZDlunGiooVjDlebmt7niXCtCUJNAFwoxVCGzQOtV/F5EUbrNqUKkQhbYBheToRn7nyh3uEsj1oCD18o2v2tFJjsrT0MfeRNIdwzdYJQDtFI2AHGWM5jyokVW9rSWSJSRmC0ZEFMLTdLTu85u01tep9KuGQEVcJu14/ghdHEpTI72JIQuG3JDPmagkOzbS4QZoq1f7XiANNfu9qK+aOAbh6HKXIgE342eLyBLZH3pvDrvd5Qy8XiF644eCr7hHCV5Eyw5/rKXYi5kPro5kcsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199021)(30864003)(2906002)(66556008)(66446008)(66476007)(52536014)(41300700001)(64756008)(4326008)(66946007)(8676002)(76116006)(26005)(316002)(110136005)(71200400001)(45080400002)(478600001)(107886003)(9686003)(8936002)(5660300002)(6506007)(7696005)(38070700005)(186003)(38100700002)(83380400001)(86362001)(66574015)(122000001)(55016003)(33656002)(82960400001)(46492015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ep9W86wyHHdtrZgMP2id1eLux6Hw+g6dn0MZPrMlqZ9ibv2fKb4J2g8C1m?=
 =?iso-8859-1?Q?iZ3apfiOfn9c7gtW9lnWjGRcrBqh8JMxhgSign69E/IX1CRZb67PdySbAS?=
 =?iso-8859-1?Q?BzYfmYQImnEWZicVF6OAFY/mqt4N1vauEQp4O2/WUyeWjE5lgqQ+PhqSF6?=
 =?iso-8859-1?Q?qP3tkyeYeDztQUnWBAbUuC7y2DRhL8e/281h/Iwxo0OlTewgFYVOu6oqWz?=
 =?iso-8859-1?Q?Q9H3bcr9T1sOdjOgywHHeUL7oUbU8RoIGkYpCwZmYkDBUu2EQ3aMBN928u?=
 =?iso-8859-1?Q?akAzGpgTRgGKB1ebnStfmLtFxLRoqtwsYZlhtbOFsCZu60aM0+MNYhl9mz?=
 =?iso-8859-1?Q?vfCNNIqgW3bD7CQfC+Ieq7HkcNPFYfx63RGu9xITeggVC3v+hJfLOgAW9R?=
 =?iso-8859-1?Q?fpsox3YuY1EOp8iyQWK02SnJkgKfdLlaEToI08++nhaq0V76RRqey4nlRc?=
 =?iso-8859-1?Q?g5flP5ZajH4aCiwtrqW0VlfoHpzm0NSt86MpH4sJuDTUEvgufczu3s/4xG?=
 =?iso-8859-1?Q?vhjiB/9whZxBGzovDuifXZA2ALVPp2RFoHrXbhDsyCL8CcB0HkovvmZx/w?=
 =?iso-8859-1?Q?d6ls3GIuyVJlKNAPgGWiKf3/79IkLN9SFXW6Lksf62VXY99yE/Osl4RjKq?=
 =?iso-8859-1?Q?/sCR+A130NVL8Q1HfBEBuUQFQPPS2AP8/T/1quWTlgKP7xIrn4qBI5035+?=
 =?iso-8859-1?Q?GiCpY72wRIrmigAgImRMy3B0fWmufnI1g1BkNzJy666hX1nRrK59KNfrvv?=
 =?iso-8859-1?Q?9WoJZBrfoGrQXSn3O73wvcikF0ki/2e/wpsCZ2VyuwRopa8wiLtFmBh6zY?=
 =?iso-8859-1?Q?bwgZEdGxMMbcCcsjUigYHzSbCxUYL1ApgGym/1S4nf7C/yDtEsWDfLBHgr?=
 =?iso-8859-1?Q?Hv7VSod7BibNpHWqOqVDdPQdNNTu4BD13U6FCHL5Yx3DjYgPWZiNtYyG7R?=
 =?iso-8859-1?Q?OpPA4q3pV+QIMT5wVx29jnRizlBZDzL4gN4uPHmZhtSaHxaJZw4vQsDLyD?=
 =?iso-8859-1?Q?GQ2il34yqyrii/teNLqM+yymCtzzOMCn+endSKtHlNT2PzgSD5haSEwLaU?=
 =?iso-8859-1?Q?lYMj2i2JlqLLuEE8wxmSTex4UKGMnSQnfx47qNY1+j0Ya7hXaslRhUqYR2?=
 =?iso-8859-1?Q?DwbkdCcInlRiZw1h6qlOZVxeaVzPNTCi1uJER1BKSLjVAAnZapYRcn1JAz?=
 =?iso-8859-1?Q?mpBmp5q+vtFc3jEd8EprGb6EorQd0ZpigvIDyWAIKorItnegBzoW2+4bf6?=
 =?iso-8859-1?Q?EZU06czuW7px0vkkH2hEd7Uo2KpCvatKIpzXj7dpefisJ8raRRy+puhDir?=
 =?iso-8859-1?Q?82/jXFPjhgof1xhvK6B5JSyyt1A7qjxUOmboh472QlFBVucFx7puSvT0Ak?=
 =?iso-8859-1?Q?1If+r1WGXWlxek/azXcF/bJS2sLdteFbQB5iAupuqYs11QVA+FkLZhxsaD?=
 =?iso-8859-1?Q?Tbrt9IGeiufHwzvlFxLMom1Srw5Nqb+K0EhffHqgYqSgfLGVH03eXNiGCh?=
 =?iso-8859-1?Q?Aqbe1u9w7s4LAzsjb7ifjLVaOo8nIFR8E+BaVl381l4HM6RIjEZQV5cHHw?=
 =?iso-8859-1?Q?bVZ4qgl5S1tJkhsvhcVVfDc992fXShGH2wJ0kbRZV8k7ydlA+mSzFotpPh?=
 =?iso-8859-1?Q?ag/KuQ0Q3K8jHy8uyibRtdaCXyGnlZfVPknMcoYouERAwhVeAf5miXmA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mail.schwarz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e82129-ece5-4f03-5f60-08db31b0afc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 06:25:13.5520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d04f4717-5a6e-4b98-b3f9-6918e0385f4c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GgAUyH9yneeuVuK+Rq4wfnIit4bDJoQFfm0Dkk1oHree+TcRiXPiaRyQg8AL1Q7XtHJT8XQpqt1V6OIsWjrJ1VCKlskbmjtE9+dGQEsoEvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR10MB7009
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

assume the following setup on a single machine:
1. An openvswitch instance with one bridge and default flows
2. two network namespaces "server" and "client"
3. two ovs interfaces "server" and "client" on the bridge
4. for each ovs interface a veth pair with a matching name and 32 rx and
   tx queues
5. move the ends of the veth pairs to the respective network namespaces
6. assign ip addresses to each of the veth ends in the namespaces (needs
   to be the same subnet)
7. start some http server on the server network namespace
8. test if a client in the client namespace can reach the http server

when following the actions below the host has a chance of getting a cpu
stuck in a infinite loop:
1. send a large amount of parallel requests to the http server (around
   3000 curls should work)
2. in parallel delete the network namespace (do not delete interfaces or
   stop the server, just kill the namespace)

there is a low chance that this will cause the below kernel cpu stuck
message. If this does not happen just retry.
Below there is also the output of bpftrace for the functions mentioned
in the output.

The series of events happening here is:
1. the network namespace is deleted calling
   `unregister_netdevice_many_notify` somewhere in the process
2. this sets first `NETREG_UNREGISTERING` on both ends of the veth and
   then runs `synchronize_net`
3. it then calls `call_netdevice_notifiers` with `NETDEV_UNREGISTER`
4. this is then handled by `dp_device_event` which calls
   `ovs_netdev_detach_dev` (if a vport is found, which is the case for
   the veth interface attached to ovs)
5. this removes the rx_handlers of the device but does not prevent
   packages to be sent to the device
6. `dp_device_event` then queues the vport deletion to work in
   background as a ovs_lock is needed that we do not hold in the
   unregistration path
7. `unregister_netdevice_many_notify` continues to call
   `netdev_unregister_kobject` which sets `real_num_tx_queues` to 0
8. port deletion continues (but details are not relevant for this issue)
9. at some future point the background task deletes the vport

If after 7. but before 9. a packet is send to the ovs vport (which is
not deleted at this point in time) which forwards it to the
`dev_queue_xmit` flow even though the device is unregistering.
In `skb_tx_hash` (which is called in the `dev_queue_xmit`) path there is
a while loop (if the packet has a rx_queue recorded) that is infinite if
`dev->real_num_tx_queues` is zero.

To prevent this from happening we update `do_output` to handle not
registered (so e.g. unregistering) devices the same as if the device is
not found (which would be the code path after 9. is done).

Additionally we introduce a `BUG_ON` in `skb_tx_hash` to rather crash
then produce this infinite loop that can not be exited anyway.

bpftrace (first word is function name):

__dev_queue_xmit server: real_num_tx_queues: 1, cpu: 2, pid: 28024, tid: 28=
024, skb_addr: 0xffff9edb6f207000, reg_state: 1
netdev_core_pick_tx server: addr: 0xffff9f0a46d4a000 real_num_tx_queues: 1,=
 cpu: 2, pid: 28024, tid: 28024, skb_addr: 0xffff9edb6f207000, reg_state: 1
dp_device_event server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid: 21024=
, event 2, reg_state: 1
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
dp_device_event server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid: 21024=
, event 6, reg_state: 2
ovs_netdev_detach_dev server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid:=
 21024, reg_state: 2
netdev_rx_handler_unregister server: real_num_tx_queues: 1, cpu: 9, pid: 21=
024, tid: 21024, reg_state: 2
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
netdev_rx_handler_unregister ret server: real_num_tx_queues: 1, cpu: 9, pid=
: 21024, tid: 21024, reg_state: 2
dp_device_event server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid: 21024=
, event 27, reg_state: 2
dp_device_event server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid: 21024=
, event 22, reg_state: 2
dp_device_event server: real_num_tx_queues: 1 cpu 9, pid: 21024, tid: 21024=
, event 18, reg_state: 2
netdev_unregister_kobject: real_num_tx_queues: 1, cpu: 9, pid: 21024, tid: =
21024
synchronize_rcu_expedited: cpu 9, pid: 21024, tid: 21024
ovs_vport_send server: real_num_tx_queues: 0, cpu: 2, pid: 28024, tid: 2802=
4, skb_addr: 0xffff9edb6f207000, reg_state: 2
__dev_queue_xmit server: real_num_tx_queues: 0, cpu: 2, pid: 28024, tid: 28=
024, skb_addr: 0xffff9edb6f207000, reg_state: 2
netdev_core_pick_tx server: addr: 0xffff9f0a46d4a000 real_num_tx_queues: 0,=
 cpu: 2, pid: 28024, tid: 28024, skb_addr: 0xffff9edb6f207000, reg_state: 2
broken device server: real_num_tx_queues: 0, cpu: 2, pid: 28024, tid: 28024
ovs_dp_detach_port server: real_num_tx_queues: 0 cpu 9, pid: 9124, tid: 912=
4, reg_state: 2
synchronize_rcu_expedited: cpu 9, pid: 33604, tid: 33604

stuck message:

watchdog: BUG: soft lockup - CPU#5 stuck for 26s! [curl:1929279]
Modules linked in: veth pktgen bridge stp llc ip_set_hash_net nft_counter x=
t_set nft_compat nf_tables ip_set_hash_ip ip_set nfnetlink_cttimeout nfnetl=
ink openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defr=
ag_ipv4 tls binfmt_misc nls_iso8859_1 input_leds joydev serio_raw dm_multip=
ath scsi_dh_rdac scsi_dh_emc scsi_dh_alua sch_fq_codel drm efi_pstore virti=
o_rng ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10=
 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor rai=
d6_pq libcrc32c raid1 raid0 multipath linear hid_generic usbhid hid crct10d=
if_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel virtio_net ahci net_=
failover crypto_simd cryptd psmouse libahci virtio_blk failover
CPU: 5 PID: 1929279 Comm: curl Not tainted 5.15.0-67-generic #74-Ubuntu
Hardware name: OpenStack Foundation OpenStack Nova, BIOS rel-1.16.0-0-gd239=
552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:netdev_pick_tx+0xf1/0x320
Code: 00 00 8d 48 ff 0f b7 c1 66 39 ca 0f 86 e9 01 00 00 45 0f b7 ff 41 39 =
c7 0f 87 5b 01 00 00 44 29 f8 41 39 c7 0f 87 4f 01 00 00 <eb> f2 0f 1f 44 0=
0 00 49 8b 94 24 28 04 00 00 48 85 d2 0f 84 53 01
RSP: 0018:ffffb78b40298820 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff9c8773adc2e0 RCX: 000000000000083f
RDX: 0000000000000000 RSI: ffff9c8773adc2e0 RDI: ffff9c870a25e000
RBP: ffffb78b40298858 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff9c870a25e000
R13: ffff9c870a25e000 R14: ffff9c87fe043480 R15: 0000000000000000
FS:  00007f7b80008f00(0000) GS:ffff9c8e5f740000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7b80f6a0b0 CR3: 0000000329d66000 CR4: 0000000000350ee0
Call Trace:
 <IRQ>
 netdev_core_pick_tx+0xa4/0xb0
 __dev_queue_xmit+0xf8/0x510
 ? __bpf_prog_exit+0x1e/0x30
 dev_queue_xmit+0x10/0x20
 ovs_vport_send+0xad/0x170 [openvswitch]
 do_output+0x59/0x180 [openvswitch]
 do_execute_actions+0xa80/0xaa0 [openvswitch]
 ? kfree+0x1/0x250
 ? kfree+0x1/0x250
 ? kprobe_perf_func+0x4f/0x2b0
 ? flow_lookup.constprop.0+0x5c/0x110 [openvswitch]
 ovs_execute_actions+0x4c/0x120 [openvswitch]
 ovs_dp_process_packet+0xa1/0x200 [openvswitch]
 ? ovs_ct_update_key.isra.0+0xa8/0x120 [openvswitch]
 ? ovs_ct_fill_key+0x1d/0x30 [openvswitch]
 ? ovs_flow_key_extract+0x2db/0x350 [openvswitch]
 ovs_vport_receive+0x77/0xd0 [openvswitch]
 ? __htab_map_lookup_elem+0x4e/0x60
 ? bpf_prog_680e8aff8547aec1_kfree+0x3b/0x714
 ? trace_call_bpf+0xc8/0x150
 ? kfree+0x1/0x250
 ? kfree+0x1/0x250
 ? kprobe_perf_func+0x4f/0x2b0
 ? kprobe_perf_func+0x4f/0x2b0
 ? __mod_memcg_lruvec_state+0x63/0xe0
 netdev_port_receive+0xc4/0x180 [openvswitch]
 ? netdev_port_receive+0x180/0x180 [openvswitch]
 netdev_frame_hook+0x1f/0x40 [openvswitch]
 __netif_receive_skb_core.constprop.0+0x23d/0xf00
 __netif_receive_skb_one_core+0x3f/0xa0
 __netif_receive_skb+0x15/0x60
 process_backlog+0x9e/0x170
 __napi_poll+0x33/0x180
 net_rx_action+0x126/0x280
 ? ttwu_do_activate+0x72/0xf0
 __do_softirq+0xd9/0x2e7
 ? rcu_report_exp_cpu_mult+0x1b0/0x1b0
 do_softirq+0x7d/0xb0
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x54/0x60
 ip_finish_output2+0x191/0x460
 __ip_finish_output+0xb7/0x180
 ip_finish_output+0x2e/0xc0
 ip_output+0x78/0x100
 ? __ip_finish_output+0x180/0x180
 ip_local_out+0x5e/0x70
 __ip_queue_xmit+0x184/0x440
 ? tcp_syn_options+0x1f9/0x300
 ip_queue_xmit+0x15/0x20
 __tcp_transmit_skb+0x910/0x9c0
 ? __mod_memcg_state+0x44/0xa0
 tcp_connect+0x437/0x4e0
 ? ktime_get_with_offset+0x60/0xf0
 tcp_v4_connect+0x436/0x530
 __inet_stream_connect+0xd4/0x3a0
 ? kprobe_perf_func+0x4f/0x2b0
 ? aa_sk_perm+0x43/0x1c0
 inet_stream_connect+0x3b/0x60
 __sys_connect_file+0x63/0x70
 __sys_connect+0xa6/0xd0
 ? setfl+0x108/0x170
 ? do_fcntl+0xe8/0x5a0
 __x64_sys_connect+0x18/0x20
 do_syscall_64+0x5c/0xc0
 ? __x64_sys_fcntl+0xa9/0xd0
 ? exit_to_user_mode_prepare+0x37/0xb0
 ? syscall_exit_to_user_mode+0x27/0x50
 ? do_syscall_64+0x69/0xc0
 ? __sys_setsockopt+0xea/0x1e0
 ? exit_to_user_mode_prepare+0x37/0xb0
 ? syscall_exit_to_user_mode+0x27/0x50
 ? __x64_sys_setsockopt+0x1f/0x30
 ? do_syscall_64+0x69/0xc0
 ? irqentry_exit+0x1d/0x30
 ? exc_page_fault+0x89/0x170
 entry_SYSCALL_64_after_hwframe+0x61/0xcb
RIP: 0033:0x7f7b8101c6a7
Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa =
64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2a 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 51 c3 48 83 ec 18 89 54 24 0c 48 89 34 24 89
RSP: 002b:00007ffffd6b2198 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b8101c6a7
RDX: 0000000000000010 RSI: 00007ffffd6b2360 RDI: 0000000000000005
RBP: 0000561f1370d560 R08: 00002795ad21d1ac R09: 0030312e302e302e
R10: 00007ffffd73f080 R11: 0000000000000246 R12: 0000561f1370c410
R13: 0000000000000000 R14: 0000000000000005 R15: 0000000000000000
 </TASK>

Co-developed-by: Luca Czesla <luca.czesla@mail.schwarz>
Signed-off-by: Luca Czesla <luca.czesla@mail.schwarz>
Signed-off-by: Felix Huettner <felix.huettner@mail.schwarz>
---
 net/core/dev.c            | 1 +
 net/openvswitch/actions.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 253584777101..6628323b7bea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3199,6 +3199,7 @@ static u16 skb_tx_hash(const struct net_device *dev,
        }

        if (skb_rx_queue_recorded(skb)) {
+               BUG_ON(unlikely(qcount =3D=3D 0));
                hash =3D skb_get_rx_queue(skb);
                if (hash >=3D qoffset)
                        hash -=3D qoffset;
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index ca3ebfdb3023..33b317e5f9a5 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -913,7 +913,7 @@ static void do_output(struct datapath *dp, struct sk_bu=
ff *skb, int out_port,
 {
        struct vport *vport =3D ovs_vport_rcu(dp, out_port);

-       if (likely(vport)) {
+       if (likely(vport && vport->dev->reg_state =3D=3D NETREG_REGISTERED)=
) {
                u16 mru =3D OVS_CB(skb)->mru;
                u32 cutlen =3D OVS_CB(skb)->cutlen;

--
2.40.0

Diese E Mail enth=E4lt m=F6glicherweise vertrauliche Inhalte und ist nur f=
=FCr die Verwertung durch den vorgesehenen Empf=E4nger bestimmt. Sollten Si=
e nicht der vorgesehene Empf=E4nger sein, setzen Sie den Absender bitte unv=
erz=FCglich in Kenntnis und l=F6schen diese E Mail. Hinweise zum Datenschut=
z finden Sie hier<https://www.datenschutz.schwarz>.
