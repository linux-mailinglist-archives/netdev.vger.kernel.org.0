Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F615ABFDD
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 18:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiICQrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 12:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiICQrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 12:47:39 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AB256B96
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:47:38 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 11so7346797ybu.0
        for <netdev@vger.kernel.org>; Sat, 03 Sep 2022 09:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=lvkxcnlPQZvKuh0fr0imW9gSJhQfWibIyDeZykVGEf4=;
        b=fQw/c6hnz9SYfKYOGkj4SCJXbibOELFo6ZkP1tUULOLH3vq8W+y98cItuhbmROUo4V
         wQSo1gwIHoJfaEKtqYIE0SXtix6l5MQM3kZESRqFrVKoKPzMbgyZdJ9PJ9oKQnHFsHPX
         pH020gI5olr5Kcrhl6oUWhgKu6WvY+hwARbbBPQpiz3y8mvQn4/Mt/PRfNI5fcjPVQ92
         crh4eAppc5mQs9VrlA320KpNcmvR/APdiXbYDn+MymSEytH1QBU4ozMZFkR94Cujbi8A
         ViNzC/UZX/Zbcx+tC18JlLX225P8X8ieUdAIsQgml8qMyOvLYNPujs5avjnbe4WPfTZB
         naFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lvkxcnlPQZvKuh0fr0imW9gSJhQfWibIyDeZykVGEf4=;
        b=g+MVpF+QqI43wWaeOe+ZSj5w+LjaQELec4sTfiwOdV1tKMQ3Z/lXwyN+lR7iZ5ixnQ
         xgl5b08/6xZys/Eu52pzT5Nx87ECPoWquc3OPgwl7XPvb/9nG9zOZJH9fDqerlqZcITz
         3IEV0S1FXH+FYoZ22sr09ZNEutXOgfUyl8IcAw1d17MGEmbOgNUwSUK/94fJhbM1cKGZ
         efCTMHc7Vsnk4khKUl31D/In+v97+DhRnsiXJxXHl9xDRUDAhy0MdD5/QlPZvpNm1Z47
         aYfgL4zhzbBdAo7xovufNu6unpinYWyE2KbVBt3eoNR3jwC1tw5Wd4ZyVh2974wwueq5
         RkWA==
X-Gm-Message-State: ACgBeo35poQ64YLu59tCDqrys1/b3evSONDX4oEgZGTbGF2Mr6EknlvM
        CRGlzQLusYgKuXiIYUKfQ8DGUwYazo/T7WFEnCv++w==
X-Google-Smtp-Source: AA6agR6GhLu5kh/7WsCNnTD4pJk7Yt+aGwWIaaGom3Z5OAMej+ePQhB+zYVopO1Uu/f4MBIykM2OACWkk1cAOgaBDmg=
X-Received: by 2002:a25:7cc6:0:b0:67a:6a2e:3d42 with SMTP id
 x189-20020a257cc6000000b0067a6a2e3d42mr26811453ybc.231.1662223657182; Sat, 03
 Sep 2022 09:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220728051821.3160118-1-eric.dumazet@gmail.com>
 <c1b350f033f0e07f45351689499bbed98b987f3e.camel@redhat.com>
 <CANn89iLQibnxDzQmuNB2qJ98wvC_R99OD3bPJVEsREmtUPxiXQ@mail.gmail.com>
 <0ca8e102e553c86bb0e3f2e6d76c883ff8d411b1.camel@redhat.com>
 <CANn89i+qDDtnUvF5F5zz5pHNzC=pxvJ8-uyta5aLtgSGwh5pcg@mail.gmail.com> <b7ea9aaf-374a-c4dd-2fef-ace17a8ccae2@gmail.com>
In-Reply-To: <b7ea9aaf-374a-c4dd-2fef-ace17a8ccae2@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 3 Sep 2022 09:47:26 -0700
Message-ID: <CANn89iJRppvogY5FFp5cACd4yZCp000EqjU5_-KqStH55METCg@mail.gmail.com>
Subject: Re: [PATCH net] ax25: fix incorrect dev_tracker usage
To:     Bernard Pidoux <bernard.f6bvp@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Duoming Zhou <duoming@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 3, 2022 at 1:57 AM Bernard Pidoux <bernard.f6bvp@gmail.com> wro=
te:
>
> This patch is still not applied to net-next.
> This is probably due to renaming thing ... that was confusing.
>
> Any possibility to build on for old stables ?
>
> Eric could you clarify the situation ?
>
> Regards,
>
> Bernard
>


Patch is definitely there.

Let me point you to the relevant parts, with a fake diff on the
current net-next tree.

diff --git a/include/net/ax25.h b/include/net/ax25.h
index f8cf3629a41934f96f33e5d70ad90cc8ae796d38..025a9f5d9f67d77897e3caf4c2c=
a1ef4b42c8c6c
100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -236,7 +236,7 @@ typedef struct ax25_cb {
        ax25_address            source_addr, dest_addr;
        ax25_digi               *digipeat;
        ax25_dev                *ax25_dev;
-       netdevice_tracker       dev_tracker;
+//     netdevice_tracker       dev_tracker;
        unsigned char           iamdigi;
        unsigned char           state, modulus, pidincl;
        unsigned short          vs, vr, va;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6b4c25a9237746265158900ab92d7f411b77ab79..c0a2e860eeaa76a7cd4c9f8068a=
a03659ce9452a
100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1066,7 +1066,7 @@ static int ax25_release(struct socket *sock)
                        del_timer_sync(&ax25->t3timer);
                        del_timer_sync(&ax25->idletimer);
                }
-               netdev_put(ax25_dev->dev, &ax25->dev_tracker);
+//             netdev_put(ax25_dev->dev, &ax25->dev_tracker);
                ax25_dev_put(ax25_dev);
        }

@@ -1147,7 +1147,7 @@ static int ax25_bind(struct socket *sock, struct
sockaddr *uaddr, int addr_len)

        if (ax25_dev) {
                ax25_fillin_cb(ax25, ax25_dev);
-               netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
+//             netdev_hold(ax25_dev->dev, &ax25->dev_tracker, GFP_ATOMIC);
        }

 done:


> Le 03/08/2022 =C3=A0 09:15, Eric Dumazet a =C3=A9crit :
> > On Wed, Aug 3, 2022 at 12:03 AM Paolo Abeni <pabeni@redhat.com> wrote:
> >>
> >> On Tue, 2022-08-02 at 23:46 -0700, Eric Dumazet wrote:
> >>> On Tue, Aug 2, 2022 at 11:23 PM Paolo Abeni <pabeni@redhat.com> wrote=
:
> >>>>
> >>>> On Wed, 2022-07-27 at 22:18 -0700, Eric Dumazet wrote:
> >>>>> From: Eric Dumazet <edumazet@google.com>
> >>>>>
> >>>>> While investigating a separate rose issue [1], and enabling
> >>>>> CONFIG_NET_DEV_REFCNT_TRACKER=3Dy, Bernard reported an orthogonal a=
x25 issue [2]
> >>>>>
> >>>>> An ax25_dev can be used by one (or many) struct ax25_cb.
> >>>>> We thus need different dev_tracker, one per struct ax25_cb.
> >>>>>
> >>>>> After this patch is applied, we are able to focus on rose.
> >>>>>
> >>>>> [1] https://lore.kernel.org/netdev/fb7544a1-f42e-9254-18cc-c9b071f4=
ca70@free.fr/
> >>>>>
> >>>>> [2]
> >>>>> [  205.798723] reference already released.
> >>>>> [  205.798732] allocated in:
> >>>>> [  205.798734]  ax25_bind+0x1a2/0x230 [ax25]
> >>>>> [  205.798747]  __sys_bind+0xea/0x110
> >>>>> [  205.798753]  __x64_sys_bind+0x18/0x20
> >>>>> [  205.798758]  do_syscall_64+0x5c/0x80
> >>>>> [  205.798763]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> [  205.798768] freed in:
> >>>>> [  205.798770]  ax25_release+0x115/0x370 [ax25]
> >>>>> [  205.798778]  __sock_release+0x42/0xb0
> >>>>> [  205.798782]  sock_close+0x15/0x20
> >>>>> [  205.798785]  __fput+0x9f/0x260
> >>>>> [  205.798789]  ____fput+0xe/0x10
> >>>>> [  205.798792]  task_work_run+0x64/0xa0
> >>>>> [  205.798798]  exit_to_user_mode_prepare+0x18b/0x190
> >>>>> [  205.798804]  syscall_exit_to_user_mode+0x26/0x40
> >>>>> [  205.798808]  do_syscall_64+0x69/0x80
> >>>>> [  205.798812]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> [  205.798827] ------------[ cut here ]------------
> >>>>> [  205.798829] WARNING: CPU: 2 PID: 2605 at lib/ref_tracker.c:136 r=
ef_tracker_free.cold+0x60/0x81
> >>>>> [  205.798837] Modules linked in: rose netrom mkiss ax25 rfcomm cma=
c algif_hash algif_skcipher af_alg bnep snd_hda_codec_hdmi nls_iso8859_1 i9=
15 rtw88_8821ce rtw88_8821c x86_pkg_temp_thermal rtw88_pci intel_powerclamp=
 rtw88_core snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio coret=
emp snd_hda_intel kvm_intel snd_intel_dspcfg mac80211 snd_hda_codec kvm i2c=
_algo_bit drm_buddy drm_dp_helper btusb drm_kms_helper snd_hwdep btrtl snd_=
hda_core btbcm joydev crct10dif_pclmul btintel crc32_pclmul ghash_clmulni_i=
ntel mei_hdcp btmtk intel_rapl_msr aesni_intel bluetooth input_leds snd_pcm=
 crypto_simd syscopyarea processor_thermal_device_pci_legacy sysfillrect cr=
yptd intel_soc_dts_iosf snd_seq sysimgblt ecdh_generic fb_sys_fops rapl lib=
arc4 processor_thermal_device intel_cstate processor_thermal_rfim cec snd_t=
imer ecc snd_seq_device cfg80211 processor_thermal_mbox mei_me processor_th=
ermal_rapl mei rc_core at24 snd intel_pch_thermal intel_rapl_common ttm sou=
ndcore int340x_thermal_zone video
> >>>>> [  205.798948]  mac_hid acpi_pad sch_fq_codel ipmi_devintf ipmi_msg=
handler drm msr parport_pc ppdev lp parport ramoops pstore_blk reed_solomon=
 pstore_zone efi_pstore ip_tables x_tables autofs4 hid_generic usbhid hid i=
2c_i801 i2c_smbus r8169 xhci_pci ahci libahci realtek lpc_ich xhci_pci_rene=
sas [last unloaded: ax25]
> >>>>> [  205.798992] CPU: 2 PID: 2605 Comm: ax25ipd Not tainted 5.18.11-F=
6BVP #3
> >>>>> [  205.798996] Hardware name: To be filled by O.E.M. To be filled b=
y O.E.M./CK3, BIOS 5.011 09/16/2020
> >>>>> [  205.798999] RIP: 0010:ref_tracker_free.cold+0x60/0x81
> >>>>> [  205.799005] Code: e8 d2 01 9b ff 83 7b 18 00 74 14 48 c7 c7 2f d=
7 ff 98 e8 10 6e fc ff 8b 7b 18 e8 b8 01 9b ff 4c 89 ee 4c 89 e7 e8 5d fd 0=
7 00 <0f> 0b b8 ea ff ff ff e9 30 05 9b ff 41 0f b6 f7 48 c7 c7 a0 fa 4e
> >>>>> [  205.799008] RSP: 0018:ffffaf5281073958 EFLAGS: 00010286
> >>>>> [  205.799011] RAX: 0000000080000000 RBX: ffff9a0bd687ebe0 RCX: 000=
0000000000000
> >>>>> [  205.799014] RDX: 0000000000000001 RSI: 0000000000000282 RDI: 000=
00000ffffffff
> >>>>> [  205.799016] RBP: ffffaf5281073a10 R08: 0000000000000003 R09: fff=
ffffffffd5618
> >>>>> [  205.799019] R10: 0000000000ffff10 R11: 000000000000000f R12: fff=
f9a0bc53384d0
> >>>>> [  205.799022] R13: 0000000000000282 R14: 00000000ae000001 R15: 000=
0000000000001
> >>>>> [  205.799024] FS:  0000000000000000(0000) GS:ffff9a0d0f300000(0000=
) knlGS:0000000000000000
> >>>>> [  205.799028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>>> [  205.799031] CR2: 00007ff6b8311554 CR3: 000000001ac10004 CR4: 000=
00000001706e0
> >>>>> [  205.799033] Call Trace:
> >>>>> [  205.799035]  <TASK>
> >>>>> [  205.799038]  ? ax25_dev_device_down+0xd9/0x1b0 [ax25]
> >>>>> [  205.799047]  ? ax25_device_event+0x9f/0x270 [ax25]
> >>>>> [  205.799055]  ? raw_notifier_call_chain+0x49/0x60
> >>>>> [  205.799060]  ? call_netdevice_notifiers_info+0x52/0xa0
> >>>>> [  205.799065]  ? dev_close_many+0xc8/0x120
> >>>>> [  205.799070]  ? unregister_netdevice_many+0x13d/0x890
> >>>>> [  205.799073]  ? unregister_netdevice_queue+0x90/0xe0
> >>>>> [  205.799076]  ? unregister_netdev+0x1d/0x30
> >>>>> [  205.799080]  ? mkiss_close+0x7c/0xc0 [mkiss]
> >>>>> [  205.799084]  ? tty_ldisc_close+0x2e/0x40
> >>>>> [  205.799089]  ? tty_ldisc_hangup+0x137/0x210
> >>>>> [  205.799092]  ? __tty_hangup.part.0+0x208/0x350
> >>>>> [  205.799098]  ? tty_vhangup+0x15/0x20
> >>>>> [  205.799103]  ? pty_close+0x127/0x160
> >>>>> [  205.799108]  ? tty_release+0x139/0x5e0
> >>>>> [  205.799112]  ? __fput+0x9f/0x260
> >>>>> [  205.799118]  ax25_dev_device_down+0xd9/0x1b0 [ax25]
> >>>>> [  205.799126]  ax25_device_event+0x9f/0x270 [ax25]
> >>>>> [  205.799135]  raw_notifier_call_chain+0x49/0x60
> >>>>> [  205.799140]  call_netdevice_notifiers_info+0x52/0xa0
> >>>>> [  205.799146]  dev_close_many+0xc8/0x120
> >>>>> [  205.799152]  unregister_netdevice_many+0x13d/0x890
> >>>>> [  205.799157]  unregister_netdevice_queue+0x90/0xe0
> >>>>> [  205.799161]  unregister_netdev+0x1d/0x30
> >>>>> [  205.799165]  mkiss_close+0x7c/0xc0 [mkiss]
> >>>>> [  205.799170]  tty_ldisc_close+0x2e/0x40
> >>>>> [  205.799173]  tty_ldisc_hangup+0x137/0x210
> >>>>> [  205.799178]  __tty_hangup.part.0+0x208/0x350
> >>>>> [  205.799184]  tty_vhangup+0x15/0x20
> >>>>> [  205.799188]  pty_close+0x127/0x160
> >>>>> [  205.799193]  tty_release+0x139/0x5e0
> >>>>> [  205.799199]  __fput+0x9f/0x260
> >>>>> [  205.799203]  ____fput+0xe/0x10
> >>>>> [  205.799208]  task_work_run+0x64/0xa0
> >>>>> [  205.799213]  do_exit+0x33b/0xab0
> >>>>> [  205.799217]  ? __handle_mm_fault+0xc4f/0x15f0
> >>>>> [  205.799224]  do_group_exit+0x35/0xa0
> >>>>> [  205.799228]  __x64_sys_exit_group+0x18/0x20
> >>>>> [  205.799232]  do_syscall_64+0x5c/0x80
> >>>>> [  205.799238]  ? handle_mm_fault+0xba/0x290
> >>>>> [  205.799242]  ? debug_smp_processor_id+0x17/0x20
> >>>>> [  205.799246]  ? fpregs_assert_state_consistent+0x26/0x50
> >>>>> [  205.799251]  ? exit_to_user_mode_prepare+0x49/0x190
> >>>>> [  205.799256]  ? irqentry_exit_to_user_mode+0x9/0x20
> >>>>> [  205.799260]  ? irqentry_exit+0x33/0x40
> >>>>> [  205.799263]  ? exc_page_fault+0x87/0x170
> >>>>> [  205.799268]  ? asm_exc_page_fault+0x8/0x30
> >>>>> [  205.799273]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>>>> [  205.799277] RIP: 0033:0x7ff6b80eaca1
> >>>>> [  205.799281] Code: Unable to access opcode bytes at RIP 0x7ff6b80=
eac77.
> >>>>> [  205.799283] RSP: 002b:00007fff6dfd4738 EFLAGS: 00000246 ORIG_RAX=
: 00000000000000e7
> >>>>> [  205.799287] RAX: ffffffffffffffda RBX: 00007ff6b8215a00 RCX: 000=
07ff6b80eaca1
> >>>>> [  205.799290] RDX: 000000000000003c RSI: 00000000000000e7 RDI: 000=
0000000000001
> >>>>> [  205.799293] RBP: 0000000000000001 R08: ffffffffffffff80 R09: 000=
0000000000028
> >>>>> [  205.799295] R10: 0000000000000000 R11: 0000000000000246 R12: 000=
07ff6b8215a00
> >>>>> [  205.799298] R13: 0000000000000000 R14: 00007ff6b821aee8 R15: 000=
07ff6b821af00
> >>>>> [  205.799304]  </TASK>
> >>>>>
> >>>>> Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by re=
binding operation")
> >>>>> Reported-by: Bernard F6BVP <f6bvp@free.fr>
> >>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >>>>> Cc: Duoming Zhou <duoming@zju.edu.cn>
> >>>>> ---
> >>>>>   include/net/ax25.h | 1 +
> >>>>>   net/ax25/af_ax25.c | 4 ++--
> >>>>>   2 files changed, 3 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/include/net/ax25.h b/include/net/ax25.h
> >>>>> index a427a05672e2aab158efd44381fe2190d9cb8969..f8cf3629a41934f96f3=
3e5d70ad90cc8ae796d38 100644
> >>>>> --- a/include/net/ax25.h
> >>>>> +++ b/include/net/ax25.h
> >>>>> @@ -236,6 +236,7 @@ typedef struct ax25_cb {
> >>>>>        ax25_address            source_addr, dest_addr;
> >>>>>        ax25_digi               *digipeat;
> >>>>>        ax25_dev                *ax25_dev;
> >>>>> +     netdevice_tracker       dev_tracker;
> >>>>>        unsigned char           iamdigi;
> >>>>>        unsigned char           state, modulus, pidincl;
> >>>>>        unsigned short          vs, vr, va;
> >>>>
> >>>> I'm sorry for the [too] late feedback, but it looks like this patch
> >>>> forgot to remove the old/unused tracker from ax25_dev, or am I missi=
ng
> >>>> something?
> >>>
> >>> I think you are confused ;)
> >>
> >> Indeed I'm (hopefully I was).
> >>
> >>
> >>> The other tracker is still used.
> >>>
> >>> Only the blamed patch (feef318c855a ("ax25: fix UAF bugs of net_devic=
e
> >>> caused by rebinding operation")) needed
> >>> a separate tracker in 'struct ax25_cb'.
> >>
> >> So this conflict resolution:
> >>
> >> https://lore.kernel.org/linux-next/20220802151932.2830110-1-broonie@ke=
rnel.org/T/#u
> >>
> >> is wrong - the first chunck must be dropped, only the last 2 are
> >> required, right?
> >
> > Indeed, this conflict resolution is wrong.
> >
> > I knew this renaming thing was going to hurt us, this is only the begin=
ning :/
> >
> > Thanks.
> >
> >>
> >> Thanks,
> >>
> >> Paolo
> >>
