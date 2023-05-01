Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C79816F3344
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjEAQAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 12:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjEAQAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 12:00:39 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09B7129
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 09:00:35 -0700 (PDT)
Date:   Mon, 01 May 2023 16:00:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samwein.com;
        s=protonmail3; t=1682956830; x=1683216030;
        bh=jgn8t9CsSeIA9ut0DwVi1y4N0nopXz+dLCLUE+SKWfQ=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=WLbgB4AgmnmFqjZ5k0l81A+XAsbiQO7CpnMkqAjV63uD05sORzKJ3JOgGXZ7unQHM
         kgHYEwwQLsqKf9ZWynURgceAQdhPAiAGVusjGHwpW3JaBTJ1IBLgQXTkZAKJjJ54Qj
         yCaLIh+/nZ6Y7uPis2UmqutDm8RHVV7ahq/l1My/5XDUddsFCg67f2gtLsrICdaKBu
         KoLA+XzbEawnf5VzvFyyCR7GCGPA9Qq71TIWl5oCQ7ehnDwl2ZaHrDjIFvR2sFGFLL
         sZcBX6LXvMzWNoHI5UetIbSC+n6eX2ZLSRS9kbCBLGGOcqPViDYlyYAn7DDvmXcOcW
         E5xoOcX8FT4FA==
To:     "Kumar, M Chetan" <m.chetan.kumar@intel.com>
From:   Samuel Wein PhD <sam@samwein.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>
Subject: RE: NULL pointer dereference when removing xmm7360 PCI device
Message-ID: <XLBOI5Re2TlLQ3z7cM_QQNNUm7LPesjdaoQ0xUS7mZbWkbQo72lVm8Re2Lmh-8RxBPNprLJD1KZb-bfzOkfuvN1FVgqTpbLk3JHjkaXpe44=@samwein.com>
In-Reply-To: <SJ0PR11MB5008B5F59CA94D2C3B0E50CDD76B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com> <20230427140819.1310f4bd@kernel.org> <SJ0PR11MB5008C45C06B1DDE78A8CC874D76B9@SJ0PR11MB5008.namprd11.prod.outlook.com> <dTcfnhONbF32TfGTW1PwZCTLPv23F7YdudIWGSzoIrQ8Kc0Y1L3l5qlfXn4RvrrRxEDVAkDc5K6rbXf11FNRmteF8RztBMYZ1rkTvdp5R34=@samwein.com> <SJ0PR11MB5008B5F59CA94D2C3B0E50CDD76B9@SJ0PR11MB5008.namprd11.prod.outlook.com>
Feedback-ID: 2153553:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This appears to do the trick. I'm still having issues bringing the device b=
ack after suspend (even with the proper reset->reload->rescan sequence), so=
 I will let you know if I find any more kernel issues.

Thanks!

Sam=20




------- Original Message -------
On Friday, April 28th, 2023 at 4:24 PM, Kumar, M Chetan <m.chetan.kumar@int=
el.com> wrote:


>=20
>=20
> > -----Original Message-----
>=20
> > From: Samuel Wein PhD sam@samwein.com
> > Sent: Friday, April 28, 2023 3:18 PM
> > To: Kumar, M Chetan m.chetan.kumar@intel.com
> > Cc: Jakub Kicinski kuba@kernel.org; netdev@vger.kernel.org; linuxwwan
> > linuxwwan@intel.com
> > Subject: RE: NULL pointer dereference when removing xmm7360 PCI device
> >=20
> > I've added the full set of logs to the gist. The sequence was:
> > boot PC
> > suspend PC
> > resume PC
> > repeat the following several (it varies) times until the error:
> > `sudo echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/remove=
`
> > `echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/rescan`
> >=20
> > The XMM7360 card doesn't resume properly from suspend, with the AT
> > devices not responding to any commands. I've been working off of some o=
f
> > Shane Parslow's code to try to get ModemManager control of the device a=
nd
> > was basically trying a bunch of ways to try to reset the card, this one=
 clearly
> > didn't work, but it also clearly exposed some weirdness in how the kern=
el
> > handled the attempt. The fact that there is not a proper MBIM interface=
 for
> > this card really makes managing it difficult.
> >=20
> > ------- Original Message -------
> > On Friday, April 28th, 2023 at 11:21 AM, Kumar, M Chetan
> > m.chetan.kumar@intel.com wrote:
> >=20
> > > > -----Original Message-----
> > >=20
> > > > From: Jakub Kicinski kuba@kernel.org
> > > > Sent: Friday, April 28, 2023 2:38 AM
> > > > To: Kumar, M Chetan m.chetan.kumar@intel.com
> > > > Cc: Samuel Wein PhD sam@samwein.com; netdev@vger.kernel.org;
> > > > linuxwwan linuxwwan@intel.com
> > > > Subject: Re: NULL pointer dereference when removing xmm7360 PCI
> > > > device
> > > >=20
> > > > On Thu, 27 Apr 2023 10:31:29 +0000 Samuel Wein PhD wrote:
> > > >=20
> > > > > Hi Folks,
> > > > > I've been trying to get the xmm7360 working with IOSM and the
> > > > > ModemManager. This has been what my highschool advisor would call
> > > > > a "learning process".
> > > > > When trying `echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:0=
2:00.0/remove` I get a
> > > > > variety of errors. One of these is a kernel error
> > > > > `2023-04-27T12:23:38.937223+02:00 Nase kernel: [ 587.997430] BUG:=
 kernel NULL pointer dereference, address: 0000000000000048 2023-04-27T12:2=
3:38.937237+02:00 Nase kernel: [ 587.997447] #PF: supervisor read access in=
 kernel mode 2023-04-27T12:23:38.937238+02:00 Nase kernel: [ 587.997455] #P=
F: error_code(0x0000) - not-present page 2023-04-27T12:23:38.937241+02:00 N=
ase kernel: [ 587.997463] PGD 0 P4D 0 2023-04-27T12:23:38.937242+02:00 Nase=
 kernel: [ 587.997476] Oops: 0000 [#1] PREEMPT SMP NOPTI 2023-04- 27T12:23:=
38.937242+02:00 Nase kernel: [ 587.997489] CPU: 1 PID: 4767 Comm: bash Not =
tainted 6.3.0-060300-generic #202304232030 ...` the full log is available
> > > > > at
> > > > > https://gist.github.com/poshul/0c5ffbde6106a71adcbc132d828dbcd7
> > > > >=20
> > > > > Steps to reproduce: Boot device with xmm7360 installed and in PCI
> > > > > mode, place into suspend. Resume, and start issuing reset/remove
> > > > > commands to the PCI interface (without properly unloading the IOS=
M
> > > > > module first).
> > > > >=20
> > > > > I'm not sure how widely applicable this is but wanted to at least=
 report
> > > > > it.
> > > >=20
> > > > Intel folks, PTAL.
> > >=20
> > > I tried reproducing the issue by following the steps you mentioned bu=
t
> > > so far could not reproduce it. Could you please share the logs from b=
oot-up
> > > and procedure you carried out in steps.
> > >=20
> > > Once you boot-up the laptop, driver will be in working condition why
> > > device removal ?
>=20
>=20
> There seems to be some issue at device side due to which communication is=
 not
> getting restored after suspend exit.
>=20
> At some point device communication is broken and wwan is not initialized.
> In remove path, accessing wwan to release resource is leading to NULL poi=
nter
> exception.
>=20
> Error handling need to be corrected. Try the patch [1] it should fix.
>=20
> Another thing for restoring the communication from such state, remove and=
 rescan is
> not enough you may have to follow below procedure for a graceful recover.
>=20
> echo 1 > /sys/bus/pci/drivers/iosm/0000:01:00.0/reset -> replace BDF
>=20
> echo 1 > /sys/bus/pci/drivers/iosm/0000:01:00.0/remove
>=20
> echo 1 > /sys/bus/pci/rescan
>=20
>=20
> [1]
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/ios=
m/iosm_ipc_imem.c
> index c066b0040a3f..0b4efd2571dd 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
> @@ -565,24 +565,32 @@ static void ipc_imem_run_state_worker(struct work_s=
truct *instance)
> struct ipc_mux_config mux_cfg;
> struct iosm_imem *ipc_imem;
> u8 ctrl_chl_idx =3D 0;
> + int ret;
>=20
> ipc_imem =3D container_of(instance, struct iosm_imem, run_state_worker);
>=20
> if (ipc_imem->phase !=3D IPC_P_RUN) {
>=20
> dev_err(ipc_imem->dev,
>=20
> "Modem link down. Exit run state worker.");
> - return;
> + goto err_cp_phase;
> }
>=20
> if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
>=20
> ipc_devlink_deinit(ipc_imem->ipc_devlink);
>=20
>=20
> - if (!ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg))
> - ipc_imem->mux =3D ipc_mux_init(&mux_cfg, ipc_imem);
>=20
> + ret =3D ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg);
> + if (ret < 0)
> + goto err_cap_init;
> +
> + ipc_imem->mux =3D ipc_mux_init(&mux_cfg, ipc_imem);
>=20
> + if (!ipc_imem->mux)
>=20
> + goto err_mux_init;
> +
> + ret =3D ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
> + if (ret < 0)
> + goto err_channel_init;
>=20
> - ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
> - if (ipc_imem->mux)
>=20
> - ipc_imem->mux->wwan =3D ipc_imem->wwan;
>=20
> + ipc_imem->mux->wwan =3D ipc_imem->wwan;
>=20
>=20
> while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
> if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
> @@ -622,6 +630,15 @@ static void ipc_imem_run_state_worker(struct work_st=
ruct instance)
>=20
> / Complete all memory stores after setting bit */
> smp_mb__after_atomic();
> +
> + return;
> +
> +err_channel_init:
> + ipc_mux_deinit(ipc_imem->mux);
>=20
> +err_mux_init:
> +err_cap_init:
> +err_cp_phase:
> + ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);
>=20
> }
>=20
> static void ipc_imem_handle_irq(struct iosm_imem *ipc_imem, int irq)
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan=
/iosm/iosm_ipc_imem_ops.c
> index 66b90cc4c346..109cf8930488 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> +++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
> @@ -77,8 +77,8 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem ipc_ime=
m,
> }
>=20
> / Initialize wwan channel */
> -void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
> - enum ipc_mux_protocol mux_type)
> +int ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
> + enum ipc_mux_protocol mux_type)
> {
> struct ipc_chnl_cfg chnl_cfg =3D { 0 };
>=20
> @@ -87,7 +87,7 @@ void ipc_imem_wwan_channel_init(struct iosm_imem ipc_im=
em,
> / If modem version is invalid (0xffffffff), do not initialize WWAN. */
> if (ipc_imem->cp_version =3D=3D -1) {
>=20
> dev_err(ipc_imem->dev, "invalid CP version");
>=20
> - return;
> + return -EIO;
> }
>=20
> ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels);
>=20
> @@ -104,9 +104,13 @@ void ipc_imem_wwan_channel_init(struct iosm_imem ipc=
_imem,
>=20
> / WWAN registration. */
> ipc_imem->wwan =3D ipc_wwan_init(ipc_imem, ipc_imem->dev);
>=20
> - if (!ipc_imem->wwan)
>=20
> + if (!ipc_imem->wwan) {
>=20
> dev_err(ipc_imem->dev,
>=20
> "failed to register the ipc_wwan interfaces");
> + return -ENOMEM;
> + }
> +
> + return 0;
> }
>=20
> /* Map SKB to DMA for transfer */
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan=
/iosm/iosm_ipc_imem_ops.h
> index f8afb217d9e2..026c5bd0f999 100644
> --- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
> +++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
> @@ -91,9 +91,11 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem *ipc_i=
mem, int if_id,
> * MUX.
> * @ipc_imem: Pointer to iosm_imem struct.
> * @mux_type: Type of mux protocol.
> + *
> + * Return: 0 on success and failure value on error
> */
> -void ipc_imem_wwan_channel_init(struct iosm_imem ipc_imem,
> - enum ipc_mux_protocol mux_type);
> +int ipc_imem_wwan_channel_init(struct iosm_imem ipc_imem,
> + enum ipc_mux_protocol mux_type);
>=20
> /
> * ipc_imem_sys_devlink_open - Open a Flash/CD Channel link to CP
