Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F306B8DC0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 09:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCNIsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 04:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbjCNIsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:48:36 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF5B23868;
        Tue, 14 Mar 2023 01:48:33 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k25-20020a7bc419000000b003ed23114fa7so3866164wmi.4;
        Tue, 14 Mar 2023 01:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678783711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLoqTJZ0jGtBTjxqOzewjl7HSsVg9rZK5RAA6v4AlB8=;
        b=f22PkWTfzsAz5kq+xiCGGB3F38ZIkYRvZJR9a6kfI0PIAShqfIqTmoRAVEe4qFd8oI
         JFVfrroyptuTWkBbYq51AHaiCyEsEh5C3GQgzVo3+UiizDb6T1LezaYrS/cSU2qNjvtH
         IAzKtulxZF1NjeLoiQVwPhlyYSyNZqYzinpbAj6jQQDT/tLu29WyNVNjM/DiK7MRYwrj
         a4+NmPIiP7hTu2eM5C9qg3LrCOQS+22TN/ckBl9XmIiOQIJikHNW5bat7wyeyA2NI5rR
         PcpdzbSlH5qveZDcDwwSQbmqOFW+xs4H+YZRTboGt7uKhXLrvWqp471zwFJDJ2FTSMY2
         YnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678783711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLoqTJZ0jGtBTjxqOzewjl7HSsVg9rZK5RAA6v4AlB8=;
        b=gaY7BAGQ/b5rtG36fvLbjO8kpcB10UOzI/7sRzmdKdwBiS2xtnXPWL0Sn8k/067FMX
         7vS2+mGEfntnhCHfxnac0+jAvzyrk51JGfTTD0NqD9vfjbz+Xc6jQ9VkUJhTmBpHKzH5
         ekEsP5cA+BLdYWBdnx3UrvW2TqKJruDgQW5TW9f1xyV2+cXFJ3jA2/LQTk6206fMYnVb
         p8oFIS+K+a/zQaWx+trVRyPtzRAeHx0WMJkrJN1osE980RQO4AwXMD9cPABaQwnJI+bJ
         crGq0uvnB+SBRPGQ3+rCt6eHHGb8WClQBqlSyVuD3Pmtge5fSnGMphV2JWgup4TFm1tD
         /Osw==
X-Gm-Message-State: AO0yUKVd4iPNTFYNqq0rb/bT4gnAxvfYvJtFHIS/WEWMBRqNjiIN9b3h
        bxWuvNGqNgOP3pG3t22BtJA=
X-Google-Smtp-Source: AK7set8spdgHRICKdsbvLei82dc0i5m3q1Alfs1jyaosj4HypRqBI7NI0GK/ymZeD3EaLEQPMMtaFA==
X-Received: by 2002:a05:600c:c09:b0:3eb:253c:faae with SMTP id fm9-20020a05600c0c0900b003eb253cfaaemr13211650wmb.36.1678783711678;
        Tue, 14 Mar 2023 01:48:31 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id a11-20020a5d508b000000b002c55b0e6ef1sm1518412wrt.4.2023.03.14.01.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 01:48:31 -0700 (PDT)
Date:   Tue, 14 Mar 2023 08:48:29 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Gautam Dawar <gdawar@amd.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        jasowang@redhat.com, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Subject: Re: [PATCH net-next v2 11/14] sfc: use PF's IOMMU domain for running
 VF's MCDI commands
Message-ID: <ZBA03bY6Q8LtH0u6@gmail.com>
Mail-Followup-To: Gautam Dawar <gdawar@amd.com>,
        Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        jasowang@redhat.com, Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230307113621.64153-1-gautam.dawar@amd.com>
 <20230307113621.64153-12-gautam.dawar@amd.com>
 <ZAjNbSN38YY+vbwS@gmail.com>
 <0f32e6fc-deaf-c65c-4ffe-f8f7c1139346@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f32e6fc-deaf-c65c-4ffe-f8f7c1139346@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 10:49:08PM +0530, Gautam Dawar wrote:
> 
> On 3/8/23 23:31, Martin Habets wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Tue, Mar 07, 2023 at 05:06:13PM +0530, Gautam Dawar wrote:
> > > This changeset uses MC_CMD_CLIENT_CMD to execute VF's MCDI
> > > commands when running in vDPA mode (STATE_VDPA).
> > > Also, use the PF's IOMMU domain for executing the encapsulated
> > > VF's MCDI commands to isolate DMA of guest buffers in the VF's
> > > IOMMU domain.
> > > This patch also updates the PCIe FN's client id in the efx_nic
> > > structure which is required while running MC_CMD_CLIENT_CMD.
> > > 
> > > Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> > > ---
> > >   drivers/net/ethernet/sfc/ef100.c      |   1 +
> > >   drivers/net/ethernet/sfc/ef100_nic.c  |  35 +++++++++
> > >   drivers/net/ethernet/sfc/mcdi.c       | 108 ++++++++++++++++++++++----
> > >   drivers/net/ethernet/sfc/mcdi.h       |   2 +-
> > >   drivers/net/ethernet/sfc/net_driver.h |   2 +
> > >   drivers/net/ethernet/sfc/ptp.c        |   4 +-
> > >   6 files changed, 132 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> > > index c1c69783db7b..8453c9ba0f41 100644
> > > --- a/drivers/net/ethernet/sfc/ef100.c
> > > +++ b/drivers/net/ethernet/sfc/ef100.c
> > > @@ -465,6 +465,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
> > >        efx->type = (const struct efx_nic_type *)entry->driver_data;
> > > 
> > >        efx->pci_dev = pci_dev;
> > > +     efx->client_id = MC_CMD_CLIENT_ID_SELF;
> > >        pci_set_drvdata(pci_dev, efx);
> > >        rc = efx_init_struct(efx, pci_dev);
> > >        if (rc)
> > > diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> > > index bda4fcbe1126..cd9f724a9e64 100644
> > > --- a/drivers/net/ethernet/sfc/ef100_nic.c
> > > +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> > > @@ -206,9 +206,11 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
> > >                  "firmware reports num_mac_stats = %u\n",
> > >                  efx->num_mac_stats);
> > > 
> > > +#ifdef CONFIG_SFC_VDPA
> > More opportunities to use IS_ENABLED(CONFIG_SFC_VDPA) in this patch
> > in stead of the #ifdef.
> 
> Will fix the occurrence where nic_data->vdpa_supported is being updated.
> However, I am not sure if using something like:
> 
> if (IS_ENABLED(CONFIG_SFC_VDPA) && (new_config == EF100_BAR_CONFIG_VDPA &&
> !nic_data->vdpa_supported))
> 
> to replace
> 
> #ifdef CONFIG_SFC_VDPA
>         if (new_config == EF100_BAR_CONFIG_VDPA &&
> !nic_data->vdpa_supported) {
> 
> would be correct as vdpa_supported itself is conditionally defined:
> 
> struct ef100_nic_data {
> 
> ...
> 
> #ifdef CONFIG_SFC_VDPA
>         bool vdpa_supported; /* true if vdpa is supported on this PCIe FN */
>  ...
> 
> }

I think you're right. Since vdpa_supported is inside an #ifdef you have to
keep the code that uses it also inside an #ifdef.

Martin

> Another way would be to use nested if statements but not sure if it is
> really needed.
> 
> Thanks
> 
> > 
> > Martin
> > 
> > >        nic_data->vdpa_supported = efx_ef100_has_cap(nic_data->datapath_caps3,
> > >                                                     CLIENT_CMD_VF_PROXY) &&
> > >                                   efx->type->is_vf;
> > > +#endif
> > >        return 0;
> > >   }
> > > 
> > > @@ -1086,6 +1088,35 @@ static int ef100_check_design_params(struct efx_nic *efx)
> > >        return rc;
> > >   }
> > > 
> > > +static int efx_ef100_update_client_id(struct efx_nic *efx)
> > > +{
> > > +     struct ef100_nic_data *nic_data = efx->nic_data;
> > > +     unsigned int pf_index = PCIE_FUNCTION_PF_NULL;
> > > +     unsigned int vf_index = PCIE_FUNCTION_VF_NULL;
> > > +     efx_qword_t pciefn;
> > > +     int rc;
> > > +
> > > +     if (efx->pci_dev->is_virtfn)
> > > +             vf_index = nic_data->vf_index;
> > > +     else
> > > +             pf_index = nic_data->pf_index;
> > > +
> > > +     /* Construct PCIE_FUNCTION structure */
> > > +     EFX_POPULATE_QWORD_3(pciefn,
> > > +                          PCIE_FUNCTION_PF, pf_index,
> > > +                          PCIE_FUNCTION_VF, vf_index,
> > > +                          PCIE_FUNCTION_INTF, PCIE_INTERFACE_CALLER);
> > > +     /* look up self client ID */
> > > +     rc = efx_ef100_lookup_client_id(efx, pciefn, &efx->client_id);
> > > +     if (rc) {
> > > +             pci_warn(efx->pci_dev,
> > > +                      "%s: Failed to get client ID, rc %d\n",
> > > +                      __func__, rc);
> > > +     }
> > > +
> > > +     return rc;
> > > +}
> > > +
> > >   /*   NIC probe and remove
> > >    */
> > >   static int ef100_probe_main(struct efx_nic *efx)
> > > @@ -1173,6 +1204,10 @@ static int ef100_probe_main(struct efx_nic *efx)
> > >                goto fail;
> > >        efx->port_num = rc;
> > > 
> > > +     rc = efx_ef100_update_client_id(efx);
> > > +     if (rc)
> > > +             goto fail;
> > > +
> > >        efx_mcdi_print_fwver(efx, fw_version, sizeof(fw_version));
> > >        pci_dbg(efx->pci_dev, "Firmware version %s\n", fw_version);
> > > 
> > > diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
> > > index a7f2c31071e8..3bf1ebe05775 100644
> > > --- a/drivers/net/ethernet/sfc/mcdi.c
> > > +++ b/drivers/net/ethernet/sfc/mcdi.c
> > > @@ -145,14 +145,15 @@ void efx_mcdi_fini(struct efx_nic *efx)
> > >        kfree(efx->mcdi);
> > >   }
> > > 
> > > -static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
> > > -                               const efx_dword_t *inbuf, size_t inlen)
> > > +static void efx_mcdi_send_request(struct efx_nic *efx, u32 client_id,
> > > +                               unsigned int cmd, const efx_dword_t *inbuf,
> > > +                               size_t inlen)
> > >   {
> > >        struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> > >   #ifdef CONFIG_SFC_MCDI_LOGGING
> > >        char *buf = mcdi->logging_buffer; /* page-sized */
> > >   #endif
> > > -     efx_dword_t hdr[2];
> > > +     efx_dword_t hdr[5];
> > >        size_t hdr_len;
> > >        u32 xflags, seqno;
> > > 
> > > @@ -179,7 +180,7 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
> > >                                     MCDI_HEADER_XFLAGS, xflags,
> > >                                     MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
> > >                hdr_len = 4;
> > > -     } else {
> > > +     } else if (client_id == efx->client_id) {
> > >                /* MCDI v2 */
> > >                BUG_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
> > >                EFX_POPULATE_DWORD_7(hdr[0],
> > > @@ -194,6 +195,35 @@ static void efx_mcdi_send_request(struct efx_nic *efx, unsigned cmd,
> > >                                     MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
> > >                                     MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
> > >                hdr_len = 8;
> > > +     } else {
> > > +             /* MCDI v2 */
> > > +             WARN_ON(inlen > MCDI_CTL_SDU_LEN_MAX_V2);
> > > +             /* MCDI v2 with credentials of a different client */
> > > +             BUILD_BUG_ON(MC_CMD_CLIENT_CMD_IN_LEN != 4);
> > > +             /* Outer CLIENT_CMD wrapper command with client ID */
> > > +             EFX_POPULATE_DWORD_7(hdr[0],
> > > +                                  MCDI_HEADER_RESPONSE, 0,
> > > +                                  MCDI_HEADER_RESYNC, 1,
> > > +                                  MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> > > +                                  MCDI_HEADER_DATALEN, 0,
> > > +                                  MCDI_HEADER_SEQ, seqno,
> > > +                                  MCDI_HEADER_XFLAGS, xflags,
> > > +                                  MCDI_HEADER_NOT_EPOCH, !mcdi->new_epoch);
> > > +             EFX_POPULATE_DWORD_2(hdr[1],
> > > +                                  MC_CMD_V2_EXTN_IN_EXTENDED_CMD,
> > > +                                  MC_CMD_CLIENT_CMD,
> > > +                                  MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen + 12);
> > > +             MCDI_SET_DWORD(&hdr[2],
> > > +                            CLIENT_CMD_IN_CLIENT_ID, client_id);
> > > +
> > > +             /* MCDIv2 header for inner command */
> > > +             EFX_POPULATE_DWORD_2(hdr[3],
> > > +                                  MCDI_HEADER_CODE, MC_CMD_V2_EXTN,
> > > +                                  MCDI_HEADER_DATALEN, 0);
> > > +             EFX_POPULATE_DWORD_2(hdr[4],
> > > +                                  MC_CMD_V2_EXTN_IN_EXTENDED_CMD, cmd,
> > > +                                  MC_CMD_V2_EXTN_IN_ACTUAL_LEN, inlen);
> > > +             hdr_len = 20;
> > >        }
> > > 
> > >   #ifdef CONFIG_SFC_MCDI_LOGGING
> > > @@ -474,7 +504,8 @@ static void efx_mcdi_release(struct efx_mcdi_iface *mcdi)
> > >                        &mcdi->async_list, struct efx_mcdi_async_param, list);
> > >                if (async) {
> > >                        mcdi->state = MCDI_STATE_RUNNING_ASYNC;
> > > -                     efx_mcdi_send_request(efx, async->cmd,
> > > +                     efx_mcdi_send_request(efx, efx->client_id,
> > > +                                           async->cmd,
> > >                                              (const efx_dword_t *)(async + 1),
> > >                                              async->inlen);
> > >                        mod_timer(&mcdi->async_timer,
> > > @@ -797,7 +828,7 @@ static int efx_mcdi_proxy_wait(struct efx_nic *efx, u32 handle, bool quiet)
> > >        return mcdi->proxy_rx_status;
> > >   }
> > > 
> > > -static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> > > +static int _efx_mcdi_rpc(struct efx_nic *efx, u32 client_id, unsigned int cmd,
> > >                         const efx_dword_t *inbuf, size_t inlen,
> > >                         efx_dword_t *outbuf, size_t outlen,
> > >                         size_t *outlen_actual, bool quiet, int *raw_rc)
> > > @@ -811,7 +842,7 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> > >                return -EINVAL;
> > >        }
> > > 
> > > -     rc = efx_mcdi_rpc_start(efx, cmd, inbuf, inlen);
> > > +     rc = efx_mcdi_rpc_start(efx, client_id, cmd, inbuf, inlen);
> > >        if (rc)
> > >                return rc;
> > > 
> > > @@ -836,7 +867,8 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> > > 
> > >                        /* We now retry the original request. */
> > >                        mcdi->state = MCDI_STATE_RUNNING_SYNC;
> > > -                     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> > > +                     efx_mcdi_send_request(efx, efx->client_id, cmd,
> > > +                                           inbuf, inlen);
> > > 
> > >                        rc = _efx_mcdi_rpc_finish(efx, cmd, inlen,
> > >                                                  outbuf, outlen, outlen_actual,
> > > @@ -855,16 +887,44 @@ static int _efx_mcdi_rpc(struct efx_nic *efx, unsigned int cmd,
> > >        return rc;
> > >   }
> > > 
> > > +#ifdef CONFIG_SFC_VDPA
> > > +static bool is_mode_vdpa(struct efx_nic *efx)
> > > +{
> > > +     if (efx->pci_dev->is_virtfn &&
> > > +         efx->pci_dev->physfn &&
> > > +         efx->state == STATE_VDPA &&
> > > +         efx->vdpa_nic)
> > > +             return true;
> > > +
> > > +     return false;
> > > +}
> > > +#endif
> > > +
> > >   static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
> > >                                   const efx_dword_t *inbuf, size_t inlen,
> > >                                   efx_dword_t *outbuf, size_t outlen,
> > >                                   size_t *outlen_actual, bool quiet)
> > >   {
> > > +#ifdef CONFIG_SFC_VDPA
> > > +     struct efx_nic *efx_pf;
> > > +#endif
> > >        int raw_rc = 0;
> > >        int rc;
> > > 
> > > -     rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> > > -                        outbuf, outlen, outlen_actual, true, &raw_rc);
> > > +#ifdef CONFIG_SFC_VDPA
> > > +     if (is_mode_vdpa(efx)) {
> > > +             efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
> > > +             rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd, inbuf,
> > > +                                inlen, outbuf, outlen, outlen_actual,
> > > +                                true, &raw_rc);
> > > +     } else {
> > > +#endif
> > > +             rc = _efx_mcdi_rpc(efx, efx->client_id, cmd, inbuf,
> > > +                                inlen, outbuf, outlen, outlen_actual, true,
> > > +                                &raw_rc);
> > > +#ifdef CONFIG_SFC_VDPA
> > > +     }
> > > +#endif
> > > 
> > >        if ((rc == -EPROTO) && (raw_rc == MC_CMD_ERR_NO_EVB_PORT) &&
> > >            efx->type->is_vf) {
> > > @@ -881,9 +941,22 @@ static int _efx_mcdi_rpc_evb_retry(struct efx_nic *efx, unsigned cmd,
> > > 
> > >                do {
> > >                        usleep_range(delay_us, delay_us + 10000);
> > > -                     rc = _efx_mcdi_rpc(efx, cmd, inbuf, inlen,
> > > -                                        outbuf, outlen, outlen_actual,
> > > -                                        true, &raw_rc);
> > > +#ifdef CONFIG_SFC_VDPA
> > > +                     if (is_mode_vdpa(efx)) {
> > > +                             efx_pf = pci_get_drvdata(efx->pci_dev->physfn);
> > > +                             rc = _efx_mcdi_rpc(efx_pf, efx->client_id, cmd,
> > > +                                                inbuf, inlen, outbuf, outlen,
> > > +                                                outlen_actual, true,
> > > +                                                &raw_rc);
> > > +                     } else {
> > > +#endif
> > > +                             rc = _efx_mcdi_rpc(efx, efx->client_id,
> > > +                                                cmd, inbuf, inlen, outbuf,
> > > +                                                outlen, outlen_actual, true,
> > > +                                                &raw_rc);
> > > +#ifdef CONFIG_SFC_VDPA
> > > +                     }
> > > +#endif
> > >                        if (delay_us < 100000)
> > >                                delay_us <<= 1;
> > >                } while ((rc == -EPROTO) &&
> > > @@ -939,7 +1012,7 @@ int efx_mcdi_rpc(struct efx_nic *efx, unsigned cmd,
> > >    * function and is then responsible for calling efx_mcdi_display_error
> > >    * as needed.
> > >    */
> > > -int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
> > > +int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned int cmd,
> > >                       const efx_dword_t *inbuf, size_t inlen,
> > >                       efx_dword_t *outbuf, size_t outlen,
> > >                       size_t *outlen_actual)
> > > @@ -948,7 +1021,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
> > >                                       outlen_actual, true);
> > >   }
> > > 
> > > -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> > > +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
> > >                       const efx_dword_t *inbuf, size_t inlen)
> > >   {
> > >        struct efx_mcdi_iface *mcdi = efx_mcdi(efx);
> > > @@ -965,7 +1038,7 @@ int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> > >                return -ENETDOWN;
> > > 
> > >        efx_mcdi_acquire_sync(mcdi);
> > > -     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> > > +     efx_mcdi_send_request(efx, client_id, cmd, inbuf, inlen);
> > >        return 0;
> > >   }
> > > 
> > > @@ -1009,7 +1082,8 @@ static int _efx_mcdi_rpc_async(struct efx_nic *efx, unsigned int cmd,
> > >                 */
> > >                if (mcdi->async_list.next == &async->list &&
> > >                    efx_mcdi_acquire_async(mcdi)) {
> > > -                     efx_mcdi_send_request(efx, cmd, inbuf, inlen);
> > > +                     efx_mcdi_send_request(efx, efx->client_id,
> > > +                                           cmd, inbuf, inlen);
> > >                        mod_timer(&mcdi->async_timer,
> > >                                  jiffies + MCDI_RPC_TIMEOUT);
> > >                }
> > > diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> > > index dafab52aaef7..2c526d2edeb6 100644
> > > --- a/drivers/net/ethernet/sfc/mcdi.h
> > > +++ b/drivers/net/ethernet/sfc/mcdi.h
> > > @@ -150,7 +150,7 @@ int efx_mcdi_rpc_quiet(struct efx_nic *efx, unsigned cmd,
> > >                       efx_dword_t *outbuf, size_t outlen,
> > >                       size_t *outlen_actual);
> > > 
> > > -int efx_mcdi_rpc_start(struct efx_nic *efx, unsigned cmd,
> > > +int efx_mcdi_rpc_start(struct efx_nic *efx, u32 client_id, unsigned int cmd,
> > >                       const efx_dword_t *inbuf, size_t inlen);
> > >   int efx_mcdi_rpc_finish(struct efx_nic *efx, unsigned cmd, size_t inlen,
> > >                        efx_dword_t *outbuf, size_t outlen,
> > > diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> > > index 1da71deac71c..948c7a06403a 100644
> > > --- a/drivers/net/ethernet/sfc/net_driver.h
> > > +++ b/drivers/net/ethernet/sfc/net_driver.h
> > > @@ -859,6 +859,7 @@ struct efx_mae;
> > >    * @secondary_list: List of &struct efx_nic instances for the secondary PCI
> > >    *   functions of the controller, if this is for the primary function.
> > >    *   Serialised by rtnl_lock.
> > > + * @client_id: client ID of this PCIe function
> > >    * @type: Controller type attributes
> > >    * @legacy_irq: IRQ number
> > >    * @workqueue: Workqueue for port reconfigures and the HW monitor.
> > > @@ -1022,6 +1023,7 @@ struct efx_nic {
> > >        struct list_head secondary_list;
> > >        struct pci_dev *pci_dev;
> > >        unsigned int port_num;
> > > +     u32 client_id;
> > >        const struct efx_nic_type *type;
> > >        int legacy_irq;
> > >        bool eeh_disabled_legacy_irq;
> > > diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
> > > index 9f07e1ba7780..d90d4f6b3824 100644
> > > --- a/drivers/net/ethernet/sfc/ptp.c
> > > +++ b/drivers/net/ethernet/sfc/ptp.c
> > > @@ -1052,8 +1052,8 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
> > > 
> > >        /* Clear flag that signals MC ready */
> > >        WRITE_ONCE(*start, 0);
> > > -     rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
> > > -                             MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
> > > +     rc = efx_mcdi_rpc_start(efx, MC_CMD_CLIENT_ID_SELF, MC_CMD_PTP,
> > > +                             synch_buf, MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
> > >        EFX_WARN_ON_ONCE_PARANOID(rc);
> > > 
> > >        /* Wait for start from MCDI (or timeout) */
> > > --
> > > 2.30.1
