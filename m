Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2880D6188D4
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiKCTg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiKCTg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:36:57 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E51A1F637;
        Thu,  3 Nov 2022 12:36:56 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id d18-20020a05683025d200b00661c6f1b6a4so1566998otu.1;
        Thu, 03 Nov 2022 12:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rmgNuBrxQXBRx86EvzdCrKeC5b9wuF+i4Or8/FOZYc0=;
        b=ZBUhL5zcSfOom0gV6sTnFIx7kRlWttMYthY48IPFRaBiMkOjkAqJfDimm8SLQBhxmb
         nRa7BRmja5P7GE/vfaIG0zRi4Llp4stt27wcRDI6NeG6l/oNO9UAT/VtshvEhpFomM2N
         HoDaVYl2Dhki06JVILPlfFWZn/3fsu1x05sdRczmpHhZjup625V7MaikG835FFDvGoXF
         UsC9N4YZTFnQrCpsZcYed6l0CpkHzcmZ7vkEwdr7YvwoHqr5OnJPEYo6wp7IaODWLOhu
         Ud6BHMf8A8ZpWsrpSaWUcbiB504uelaGRgCb+YRGueyf6pEIRQ1WL4k57gcFrLUQudby
         2jrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rmgNuBrxQXBRx86EvzdCrKeC5b9wuF+i4Or8/FOZYc0=;
        b=CFVaekGDucLhwY+z98jK8n0pQZzAMirJfCbwa7KWZGwr1XImLfe13zINATHBq6aEZ5
         ioNnZvz9lx9RuJ3aEb2r717aydS5almL5Qhitoxxdf6RjtHuv4N2s8kKvy5q1cpODGrI
         mmm8VtTm9ZyZO/bcSlrpT2LE/Ha9CqLr4MYnoZl608NDU/q01T1WSntzzCUliWOtW7ZE
         gVUHbDM1ovDWRCiadneUm0xfTvfsBBPQCV0naYVLBHXWOA2NV3wBWaoiBCjDzasy9at6
         U7RnyUQqc84MfBL6ld7X8JzDDPpTDJhb+vN3dw2bf3TlUcaQAxpK073CMdNUxtSHkzbH
         9Q3A==
X-Gm-Message-State: ACrzQf1vPJT6jOCatpaSSJLUjDYkWEGrxFGmSgt26x3XDR38FpBjAmER
        DHAEW5LNOr7mjOFjVkP+gLgllAG+gjZZNg00m5QySNePdGj3tg==
X-Google-Smtp-Source: AMsMyM7L4q9bhg0gvZ2kFZU7BhnjnPXkPvBPePb7nHySiozMQTjFQfHSCsz/F/G5sEA6X8TWFR60/a/b4TT8AZTrU1c=
X-Received: by 2002:a05:6830:4182:b0:66c:2e8d:33c7 with SMTP id
 r2-20020a056830418200b0066c2e8d33c7mr16437472otu.46.1667504215744; Thu, 03
 Nov 2022 12:36:55 -0700 (PDT)
MIME-Version: 1.0
References: <7033694f-a4a5-d571-3eec-eec74aaa3e7c@huawei.com>
 <CADvbK_eLkuvpof=jsc0b+2TdMtRAjBmizAdUXsagoZLNHUMgCQ@mail.gmail.com> <2628673a6ff1418193bc31c3c1285e0c@huawei.com>
In-Reply-To: <2628673a6ff1418193bc31c3c1285e0c@huawei.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 3 Nov 2022 15:36:30 -0400
Message-ID: <CADvbK_cb+QVnGzDBgoJxwHnkTj=736F-yhdK4DPJ3DrF18q3Rw@mail.gmail.com>
Subject: Re: BUG: kernel NULL pointer dereference in sctp_sched_dequeue_common
To:     Caowangbao <caowangbao@huawei.com>
Cc:     "Chenzhen(EulerOS)" <chenzhen126@huawei.com>,
        "vyasevich@gmail.com" <vyasevich@gmail.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Yanan (Euler)" <yanan@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 5:53 AM Caowangbao <caowangbao@huawei.com> wrote:
>
> I have reduced the recurrence conditions and can reproduce the problem by=
 running the following statement:
>
> 18:00:56 executing program 0:
> r0 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
> setsockopt$inet_sctp6_SCTP_SOCKOPT_BINDX_ADD(r0, 0x84, 0x64, &(0x7f000000=
01c0)=3D[@in=3D{0x2, 0x4e20, @empty}], 0x10) (async)
> getsockopt$inet_sctp6_SCTP_SOCKOPT_CONNECTX3(r0, 0x84, 0x6f, &(0x7f000000=
0580)=3D{<r1=3D>0x0, 0x10, &(0x7f0000000540)=3D[@in=3D{0x2, 0x4e20, @local}=
]}, &(0x7f0000000600)=3D0x10) (async)
> r2 =3D dup2(r0, r0)
> setsockopt$inet_sctp6_SCTP_DEFAULT_PRINFO(r2, 0x84, 0x72, &(0x7f000000000=
0)=3D{0x0, 0x6, 0x30}, 0xc) (async)
Thanks for the statements.

The crash seems related to SCTP_PR_SCTP_PRIO.
When there is not enough buffer for the out msg, it will prune the
out_chunk_list according to the priority set by SCTP_DEFAULT_PRINFO in
sctp_prsctp_prune_unsent(). However, it doesn't clear
asoc->stream.out_curr if all frag chunks of current msg are pruned.

Can you apply this patch to your kernel and give it try?

diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e213aaf45d67..41b8065cfe65 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -384,6 +384,7 @@ static int sctp_prsctp_prune_unsent(struct
sctp_association *asoc,
 {
        struct sctp_outq *q =3D &asoc->outqueue;
        struct sctp_chunk *chk, *temp;
+       struct sctp_stream_out *sout;

        q->sched->unsched_all(&asoc->stream);

@@ -398,12 +399,12 @@ static int sctp_prsctp_prune_unsent(struct
sctp_association *asoc,
                sctp_sched_dequeue_common(q, chk);
                asoc->sent_cnt_removable--;
                asoc->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
-               if (chk->sinfo.sinfo_stream < asoc->stream.outcnt) {
-                       struct sctp_stream_out *streamout =3D
-                               SCTP_SO(&asoc->stream, chk->sinfo.sinfo_str=
eam);

-                       streamout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO=
)]++;
-               }
+               sout =3D SCTP_SO(&asoc->stream, chk->sinfo.sinfo_stream);
+               sout->ext->abandoned_unsent[SCTP_PR_INDEX(PRIO)]++;
+               if (asoc->stream.out_curr =3D=3D sout &&
+                   list_is_last(&chk->frag_list, &chk->msg->chunks))
+                       asoc->stream.out_curr =3D NULL; /* clear
out_curr if all frag chunks are pruned */

                msg_len -=3D chk->skb->truesize + sizeof(struct sctp_chunk)=
;
                sctp_chunk_free(chk);

Thanks.

> sendmmsg$sock(r2, ...) (async)
> r3 =3D socket$inet6_sctp(0xa, 0x1, 0x84)
> r4 =3D dup2(r2, r3)
> setsockopt$inet_sctp6_SCTP_DEFAULT_PRINFO(r4, 0x84, 0x72, &(0x7f000000004=
0), 0xc)
> sendmsg$alg(r4, &(0x7f0000002700)=3D{0x0, 0x0, &(0x7f0000002500)=3D[{&(0x=
7f0000004100)=3D'@', 0x1}], 0x1}, 0x0) (async)
> setsockopt$inet_sctp6_SCTP_DEFAULT_SNDINFO(r2, 0x84, 0x22, &(0x7f00000024=
80)=3D{0x5, 0x202, 0x9, 0x10001, r1}, 0x10) (async)
> write$tun(r4, &(0x7f0000002640)=3DANY=3D[@ANYBLOB=3D"00000000000000000000=
0000000006000000aaaaaaaaaabb467219e67b1d64441845437b38c12ddeb986e59e82bd424=
7f1ed8a05309a31b9494bda521ffd4b68bf072b030d7ef04cc219c73572fac79f47369d49ae=
19df01641921e3af34cb84766ede45e4fa9a14460fae51557f643d108ba54f7cb8440ce5aa0=
e60d7c2c4da"], 0x1e) (async)
> write(r0, &(0x7f0000000080)=3D"e4", 0x1)
>
>
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Caowangbao
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B411=E6=9C=883=E6=97=A5 =
10:13
> =E6=94=B6=E4=BB=B6=E4=BA=BA: 'Xin Long' <lucien.xin@gmail.com>; Chenzhen(=
EulerOS) <chenzhen126@huawei.com>
> =E6=8A=84=E9=80=81: 'vyasevich@gmail.com' <vyasevich@gmail.com>; 'nhorman=
@tuxdriver.com' <nhorman@tuxdriver.com>; 'marcelo.leitner@gmail.com' <marce=
lo.leitner@gmail.com>; 'linux-sctp@vger.kernel.org' <linux-sctp@vger.kernel=
.org>; 'davem@davemloft.net' <davem@davemloft.net>; 'edumazet@google.com' <=
edumazet@google.com>; 'kuba@kernel.org' <kuba@kernel.org>; 'pabeni@redhat.c=
om' <pabeni@redhat.com>; 'netdev@vger.kernel.org' <netdev@vger.kernel.org>;=
 Yanan (Euler) <yanan@huawei.com>
> =E4=B8=BB=E9=A2=98: =E7=AD=94=E5=A4=8D: BUG: kernel NULL pointer derefere=
nce in sctp_sched_dequeue_common
>
> It can be reproduce by the command " ./syz-execprog -procs=3D16 -repeat=
=3D0 sctp_sched_dequeue_common" with the attachments.
>
> void sctp_sched_dequeue_common(struct sctp_outq *q, struct sctp_chunk *ch=
) {
>         list_del_init(&ch->list);
>         list_del_init(&ch->stream_list);
>         q->out_qlen -=3D ch->skb->len;                    // ch->skb is n=
ull in the VMCore
> }
>
> The kernel log records=EF=BC=9A
>         [23411.786575] list_del corruption, ffffa035ddf01c18->next is NUL=
L
>         [23411.787780] WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49=
 __list_del_entry_valid+0x59/0xe0
>         ******
>         [23411.830256] Call Trace:
>         [23411.830863]  sctp_sched_dequeue_common+0x17/0x70 [sctp]
>         [23411.831940]  sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
>         [23411.832967]  sctp_outq_flush_data+0x85/0x360 [sctp] It means "=
ch->list" has no element.
>
> And in VMCore , there are many calls like:
>         #2 [ffffaf7d84f6bbb8] __lock_sock at ffffffff8ac74ef9
>         #3 [ffffaf7d84f6bc08] lock_sock_nested at ffffffff8ac74f92
>         #4 [ffffaf7d84f6bc20] sctp_wait_for_sndbuf at ffffffffc0c8d9d2 [s=
ctp]
>         #5 [ffffaf7d84f6bc98] sctp_sendmsg_to_asoc at ffffffffc0c8dd1e [s=
ctp]
>         #6 [ffffaf7d84f6bd08] sctp_sendmsg at ffffffffc0c95f55 [sctp]
>         #7 [ffffaf7d84f6bdb8] sock_sendmsg at ffffffff8ac6fd0b
>         #8 [ffffaf7d84f6bdd0] sock_write_iter at ffffffff8ac6fdb7
>         #9 [ffffaf7d84f6be48] new_sync_write at ffffffff8a784021
>         #10 [ffffaf7d84f6bed0] vfs_write at ffffffff8a784d07
>         #11 [ffffaf7d84f6bf08] ksys_write at ffffffff8a78719b
>         #12 [ffffaf7d84f6bf40] do_syscall_64 at ffffffff8ae9a8b3 It may h=
ave something to do with these concurrent invocations.
>
> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Xin Long [mailto:lucien.xin@gmail.com]
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B411=E6=9C=883=E6=97=A5 =
9:20
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Chenzhen(EulerOS) <chenzhen126@huawei.com>
> =E6=8A=84=E9=80=81: vyasevich@gmail.com; nhorman@tuxdriver.com; marcelo.l=
eitner@gmail.com; linux-sctp@vger.kernel.org; davem@davemloft.net; edumazet=
@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.org; Ca=
owangbao <caowangbao@huawei.com>; Yanan (Euler) <yanan@huawei.com>
> =E4=B8=BB=E9=A2=98: Re: BUG: kernel NULL pointer dereference in sctp_sche=
d_dequeue_common
>
> On Wed, Nov 2, 2022 at 10:29 AM Zhen Chen <chenzhen126@huawei.com> wrote:
> >
> > Hi,all
> >
> > We found the following crash when running fuzz tests on stable-5.10.
> >
> > ------------[ cut here ]------------
> > list_del corruption, ffffa035ddf01c18->next is NULL
> > WARNING: CPU: 1 PID: 250682 at lib/list_debug.c:49 __list_del_entry_val=
id+0x59/0xe0
> > CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G       =
    O
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
> > RIP: 0010:__list_del_entry_valid+0x59/0xe0
> > Code: c0 74 5a 4d 8b 00 49 39 f0 75 6a 48 8b 52 08 4c 39 c2 75 79 b8
> > 01 00 00 00 c3 cc cc cc cc 48 c7 c7 68 ae 78 8b e8 d2 3d 4e 00 <0f> 0b
> > 31 c0 c3 cc cc cc cc 48 c7 c7 90 ae 78 8b e8 bd 3d 4e 00 0f
> > RSP: 0018:ffffaf7d84a57930 EFLAGS: 00010286
> > RAX: 0000000000000000 RBX: ffffa035ddf01c18 RCX: 0000000000000000
> > RDX: ffffa035facb0820 RSI: ffffa035faca0410 RDI: ffffa035faca0410
> > RBP: ffffa035dddff6f8 R08: 0000000000000000 R09: ffffaf7d84a57770
> > R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c18
> > R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
> > FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f509a3d0ee8 CR3: 000000010f7c2001 CR4: 00000000001706e0 Call
> > Trace:
> >  sctp_sched_dequeue_common+0x17/0x70 [sctp]
> >  sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
> >  sctp_outq_flush_data+0x85/0x360 [sctp]
> >  sctp_outq_uncork+0x77/0xa0 [sctp]
> >  sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
> >  sctp_side_effects+0x37/0xe0 [sctp]
> >  sctp_do_sm+0xd0/0x230 [sctp]
> >  sctp_primitive_SEND+0x2f/0x40 [sctp]
> >  sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
> >  sctp_sendmsg+0x3d5/0x440 [sctp]
> >  sock_sendmsg+0x5b/0x70
> >  sock_write_iter+0x97/0x100
> >  new_sync_write+0x1a1/0x1b0
> >  vfs_write+0x1b7/0x250
> >  ksys_write+0xab/0xe0
> >  do_syscall_64+0x33/0x40
> >  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> > RIP: 0033:0x461e3d
> > Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
> > RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
> > RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff ---[
> > end trace 332cf75246d5ba68 ]---
> > BUG: kernel NULL pointer dereference, address: 0000000000000070
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page PGD 800000010c0d4067 P4D
> > 800000010c0d4067 PUD 10f275067 PMD 0
> > Oops: 0000 [#1] SMP PTI
> > CPU: 1 PID: 250682 Comm: syz-executor.7 Kdump: loaded Tainted: G       =
 W  O
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> > rel-1.10.2-0-g5f4c7b1-20181220_000000-szxrtosci10000 04/01/2014
> > RIP: 0010:sctp_sched_dequeue_common+0x5c/0x70 [sctp]
> > Code: 5b 08 4c 89 e7 e8 44 c5 cc c9 84 c0 74 0f 48 8b 53 18 48 8b 43
> > 20 48 89 42 08 48 89 10 48 8b 43 38 4c 89 63 18 4c 89 63 20 5b <8b> 40
> > 70 29 45 20 5d 41 5c c3 cc cc cc cc 66 0f 1f 44 00 00 0f 1f
> > RSP: 0018:ffffaf7d84a57940 EFLAGS: 00010202
> > RAX: 0000000000000000 RBX: ffffaf7d84a579a0 RCX: 0000000000000000
> > RDX: ffffa035ddf01c30 RSI: ffffa035ddf01c30 RDI: ffffa035ddf01c30
> > RBP: ffffa035dddff6f8 R08: ffffa035ddf01c30 R09: ffffaf7d84a57770
> > R10: ffffaf7d84a57768 R11: ffffffff8bddc248 R12: ffffa035ddf01c30
> > R13: ffffaf7d84a57af8 R14: ffffaf7d84a57c28 R15: 0000000000000000
> > FS:  00007fb7353ae700(0000) GS:ffffa035fac80000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000000000070 CR3: 000000010f7c2001 CR4: 00000000001706e0 Call
> > Trace:
> >  sctp_sched_fcfs_dequeue+0x37/0x50 [sctp]
> >  sctp_outq_flush_data+0x85/0x360 [sctp]
> >  sctp_outq_uncork+0x77/0xa0 [sctp]
> >  sctp_cmd_interpreter.constprop.0+0x164/0x1450 [sctp]
> >  sctp_side_effects+0x37/0xe0 [sctp]
> >  sctp_do_sm+0xd0/0x230 [sctp]
> >  sctp_primitive_SEND+0x2f/0x40 [sctp]
> >  sctp_sendmsg_to_asoc+0x3fa/0x5c0 [sctp]
> >  sctp_sendmsg+0x3d5/0x440 [sctp]
> >  sock_sendmsg+0x5b/0x70
> >  sock_write_iter+0x97/0x100
> >  new_sync_write+0x1a1/0x1b0
> >  vfs_write+0x1b7/0x250
> >  ksys_write+0xab/0xe0
> >  do_syscall_64+0x33/0x40
> >  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> > RIP: 0033:0x461e3d
> > Code: 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fb7353adc08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> > RAX: ffffffffffffffda RBX: 000000000058c1d0 RCX: 0000000000461e3d
> > RDX: 000000000000001e RSI: 0000000020002640 RDI: 0000000000000004
> > RBP: 000000000058c1d0 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fb7353ae700 R14: 00007ffc4c20ce00 R15: 0000000000000fff
> >
> >
> > It is quite similar to the issue (See
> > https://lore.kernel.org/all/CAO4mrfcB0d+qbwtfndzqcrL+QEQgfOmJYQMAdzwxR
> > ePmP8TY1A@mail.gmail.com/ ) , which was addressed by 181d8d2066c0
> > (sctp: leave the err path free in sctp_stream_init to
> > sctp_stream_free), but unfortunately the patch do not work with this
> > bug :(
> >
> So this issue is reproducible in your env?
> Can you show what it does in your test or the reproducer if there is one?
>
> Thanks.
