Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CAD3B0C9E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhFVSOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVSOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:14:20 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536D7C061574;
        Tue, 22 Jun 2021 11:12:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id w21so28070908qkb.9;
        Tue, 22 Jun 2021 11:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D7xOfxClAE0XGbOXekOrajTdpVZp4p1VXYkVa1t3B64=;
        b=vZ8sG9fDOsM73zD+H1ta/7t2hoE5UOWkVM8FXifxb76+smhhV/36Zwm5jDGM5rzStP
         OoyG78WUSNA/+c+lrt/YNOn9H/iXbitZtXXXStqJ6ffPKti0g9/eSBvGO5OoruQwulyh
         ftXF/K/vOjIw21rWOnudOOUPmaWP3rXdFsR072QmN1r8MFz91P6CjXpWBX+lnaJ7adZF
         Opxmwr1WrQ26AMlSJSAbMNePY05Ouc/wgawzRzSupyMkRPXGlpcBgg12T2ZyyuL7/ADY
         VL4L/9UFUyBRaPbU4ISKYAHNgpFo0u2SFtOvMUzUC/psPfA+1J+JOto330x54jtwFFzd
         1eLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D7xOfxClAE0XGbOXekOrajTdpVZp4p1VXYkVa1t3B64=;
        b=JipaqeG+/nVQAjOEyXc2TQDx7sWK8K4eF+ztW1iLT6U2LYFxuovgvOolRELkXY2d+7
         ifkz/Vi8X4GPu7zSWAOAqB+5tzSdjf4AmcdsBL9M5jtE2EwQxTUEOefv4VqixXdYWb9z
         u+bWV+33yU88HBJHpEnzSklN1HXpe4g2BCVXU3BK7B8X9G5H2I4nKqcovf+8kDYRguhB
         E1kSyMxCsgxfxYGUKthcm5gTtHycKHZkl3dzyockOhSdDSXdhrpHrpMpolDERDVceeWC
         d81dGnZtS0V4MJ5RHBZfCyIJThGzpTJLXccb7n8P7CsZlS+7n/gy1UrRlXoK/6xXC0eR
         MK2A==
X-Gm-Message-State: AOAM531SmE1GI80m3QWPV+4RWXqvao3nFNTCnaOfYgL+RQlwsfo3/wEn
        xYn0eNIUNnP1N4snCCKcO9ZZclEtskek9MNskqE=
X-Google-Smtp-Source: ABdhPJw6DWrinBU9wBqF4Rm5zM5rAH8tIO23mJDWKIVMzO8ceQibpWy9TWuSPFepNxdeOmB9sDV58EiCKT/+iq7foj4=
X-Received: by 2002:a05:6902:102d:: with SMTP id x13mr6842725ybt.408.1624385523386;
 Tue, 22 Jun 2021 11:12:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAJjojJvCv2aMWt_cjSC2eBNBDGwV2ottSApgmHdJmup6-+_k4w@mail.gmail.com>
 <YKc6SloWBg5maJpU@kroah.com> <CAJjojJtvYeK4N7E8MZkF8YBbp-mvjzoeJgjb=6zQB6h-5tRkNg@mail.gmail.com>
 <20210521090256.GA24442@kadam> <CAJjojJu6ZaAZOs1K=OsvA0=+ZNVATdT3YgbsqSzTYeFJFCgqzQ@mail.gmail.com>
 <20210521150454.GD24442@kadam> <20210622103232.GL1901@kadam>
In-Reply-To: <20210622103232.GL1901@kadam>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 22 Jun 2021 11:11:52 -0700
Message-ID: <CABBYNZK0yHjKM1BtjLV=AVvXDoitnkh4TzYS76c89Xft8i9q0Q@mail.gmail.com>
Subject: Re: OOB Read in hci_cc_read_local_name() cause information leak
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Lin Horse <kylin.formalin@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Greg KH <greg@kroah.com>, security@kernel.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Tue, Jun 22, 2021 at 3:34 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hi Luiz,
>
> I was looking through old bug reports that Lin Horse had reported and
> was wondering when your patchset would be applied?
>
> https://lore.kernel.org/linux-bluetooth/20210419171257.3865181-1-luiz.dentz@gmail.com/

This is on hold until I finish with the LL Privacy set, but yes we do
intend to introduce such checks in the future, I just need to address
some of Marcel's comments.

> I really like the hci_skb_pull() function and I think that it should be
> made into a top level function which all drivers can use.  It's like
> skb_pull() but it returns the old skb->data instead of skb->data + len.
> The skb_pull() still updates skb->data and skb->len.
>
> static void *skb_pull_data(struct sk_buff *skb, size_t len)
> {
>         void *data = skb->data;
>
>         if (skb->len < len)
>                 return NULL;
>
>         skb_pull(skb, len);
>
>         return data;
> }

Indeed that would be very convenient, I guess that should be added to
skbuff.h perhaps as with a inline variant as skb_pull, but that is
probably up for the net folks to decide.

> There is a lot of code that does "struct foo *p = (void *)skb->data;"
> and that's hard to audit and error prone.  Changing it to:
>
>         p = skb_pull_data(skb, sizeof(*p));
>         if (!p)
>                 return;
>
> seems more clear and safe.

+1

Feel free to propose a patch introducing skb_pull_data, I would be
happy to change my set to use it once I got back to it.

> regards,
> dan carpenter
>
> > net/bluetooth/hci_event.c:119 hci_cc_role_discovery() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:138 hci_cc_read_link_policy() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:157 hci_cc_write_link_policy() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:182 hci_cc_read_def_link_policy() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:246 hci_cc_read_stored_link_key() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:264 hci_cc_delete_stored_link_key() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:300 hci_cc_read_local_name() assignment assumes 'skb->len' is '249' bytes
> > net/bluetooth/hci_event.c:423 hci_cc_read_class_of_dev() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:460 hci_cc_read_voice_setting() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:513 hci_cc_read_num_supported_iac() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:589 hci_cc_read_local_version() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:609 hci_cc_read_local_commands() assignment assumes 'skb->len' is '65' bytes
> > net/bluetooth/hci_event.c:624 hci_cc_read_auth_payload_timeout() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:644 hci_cc_write_auth_payload_timeout() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:669 hci_cc_read_local_features() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:719 hci_cc_read_local_ext_features() assignment assumes 'skb->len' is '11' bytes
> > net/bluetooth/hci_event.c:736 hci_cc_read_flow_control_mode() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:748 hci_cc_read_buffer_size() assignment assumes 'skb->len' is '8' bytes
> > net/bluetooth/hci_event.c:774 hci_cc_read_bd_addr() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:791 hci_cc_read_local_pairing_opts() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:808 hci_cc_read_page_scan_activity() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:843 hci_cc_read_page_scan_type() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:873 hci_cc_read_data_block_size() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:892 hci_cc_read_clock() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:928 hci_cc_read_local_amp_info() assignment assumes 'skb->len' is '31' bytes
> > net/bluetooth/hci_event.c:950 hci_cc_read_inq_rsp_tx_power() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:963 hci_cc_read_def_err_data_reporting() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:993 hci_cc_pin_code_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1021 hci_cc_pin_code_neg_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1037 hci_cc_le_read_buffer_size() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:1055 hci_cc_le_read_local_features() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:1068 hci_cc_le_read_adv_tx_power() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:1080 hci_cc_user_confirm_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1096 hci_cc_user_confirm_neg_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1111 hci_cc_user_passkey_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1127 hci_cc_user_passkey_neg_reply() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:1143 hci_cc_read_local_oob_data() assignment assumes 'skb->len' is '33' bytes
> > net/bluetooth/hci_event.c:1151 hci_cc_read_local_oob_ext_data() assignment assumes 'skb->len' is '65' bytes
> > net/bluetooth/hci_event.c:1230 hci_cc_le_read_transmit_power() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:1484 hci_cc_le_read_num_adv_sets() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:1498 hci_cc_le_read_white_list_size() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:1562 hci_cc_le_read_supported_states() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:1575 hci_cc_le_read_def_data_len() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:1660 hci_cc_le_read_resolv_list_size() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:1697 hci_cc_le_read_max_data_len() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:1765 hci_cc_set_ext_adv_param() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:1796 hci_cc_read_rssi() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:1816 hci_cc_read_tx_power() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:2607 hci_conn_complete_evt() assignment assumes 'skb->len' is '11' bytes
> > net/bluetooth/hci_event.c:2731 hci_conn_request_evt() assignment assumes 'skb->len' is '10' bytes
> > net/bluetooth/hci_event.c:2842 hci_disconn_complete_evt() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:2934 hci_auth_complete_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:3004 hci_remote_name_evt() assignment assumes 'skb->len' is '255' bytes
> > net/bluetooth/hci_event.c:3087 hci_encrypt_change_evt() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:3202 hci_change_link_key_complete_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:3225 hci_remote_features_evt() assignment assumes 'skb->len' is '11' bytes
> > net/bluetooth/hci_event.c:3293 hci_cmd_complete_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:3670 hci_cmd_status_evt() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:3776 hci_hardware_error_evt() assignment assumes 'skb->len' is '1' bytes
> > net/bluetooth/hci_event.c:3785 hci_role_change_evt() assignment assumes 'skb->len' is '8' bytes
> > net/bluetooth/hci_event.c:3807 hci_num_comp_pkts_evt() assignment assumes 'skb->len' is '1' bytes
> > net/bluetooth/hci_event.c:3895 hci_num_comp_blocks_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:3946 hci_mode_change_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:3974 hci_pin_code_request_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:4044 hci_link_key_request_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:4104 hci_link_key_notify_evt() assignment assumes 'skb->len' is '23' bytes
> > net/bluetooth/hci_event.c:4164 hci_clock_offset_evt() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:4187 hci_pkt_type_change_evt() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:4203 hci_pscan_rep_mode_evt() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:4293 hci_remote_ext_features_evt() assignment assumes 'skb->len' is '13' bytes
> > net/bluetooth/hci_event.c:4357 hci_sync_conn_complete_evt() assignment assumes 'skb->len' is '17' bytes
> > net/bluetooth/hci_event.c:4505 hci_key_refresh_complete_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:4614 hci_io_capa_request_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:4683 hci_io_capa_reply_evt() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:4704 hci_user_confirm_request_evt() assignment assumes 'skb->len' is '10' bytes
> > net/bluetooth/hci_event.c:4789 hci_user_passkey_request_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:4800 hci_user_passkey_notify_evt() assignment assumes 'skb->len' is '10' bytes
> > net/bluetooth/hci_event.c:4820 hci_keypress_notify_evt() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:4859 hci_simple_pair_complete_evt() assignment assumes 'skb->len' is '7' bytes
> > net/bluetooth/hci_event.c:4890 hci_remote_host_features_evt() assignment assumes 'skb->len' is '14' bytes
> > net/bluetooth/hci_event.c:4912 hci_remote_oob_data_request_evt() assignment assumes 'skb->len' is '6' bytes
> > net/bluetooth/hci_event.c:4966 hci_chan_selected_evt() assignment assumes 'skb->len' is '1' bytes
> > net/bluetooth/hci_event.c:4983 hci_phy_link_complete_evt() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:5023 hci_loglink_complete_evt() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:5063 hci_disconn_loglink_complete_evt() assignment assumes 'skb->len' is '4' bytes
> > net/bluetooth/hci_event.c:5087 hci_disconn_phylink_complete_evt() assignment assumes 'skb->len' is '3' bytes
> > net/bluetooth/hci_event.c:5271 hci_le_conn_complete_evt() assignment assumes 'skb->len' is '18' bytes
> > net/bluetooth/hci_event.c:5285 hci_le_enh_conn_complete_evt() assignment assumes 'skb->len' is '30' bytes
> > net/bluetooth/hci_event.c:5303 hci_le_ext_adv_term_evt() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:5332 hci_le_conn_update_complete_evt() assignment assumes 'skb->len' is '9' bytes
> > net/bluetooth/hci_event.c:5749 hci_le_remote_feat_complete_evt() assignment assumes 'skb->len' is '11' bytes
> > net/bluetooth/hci_event.c:5790 hci_le_ltk_request_evt() assignment assumes 'skb->len' is '12' bytes
> > net/bluetooth/hci_event.c:5867 hci_le_remote_conn_param_req_evt() assignment assumes 'skb->len' is '10' bytes
> > net/bluetooth/hci_event.c:5944 hci_le_phy_update_evt() assignment assumes 'skb->len' is '5' bytes
> > net/bluetooth/hci_event.c:5967 hci_le_meta_evt() assignment assumes 'skb->len' is '1' bytes
> > net/bluetooth/hci_event.c:6079 hci_store_wake_reason() assignment assumes 'skb->len' is '11' bytes
> > net/bluetooth/hci_event.c:6080 hci_store_wake_reason() assignment assumes 'skb->len' is '10' bytes
> > net/bluetooth/hci_event.c:6106 hci_store_wake_reason() assignment assumes 'skb->len' is '1' bytes
> > net/bluetooth/hci_event.c:6144 hci_event_packet() assignment assumes 'skb->len' is '2' bytes
> > net/bluetooth/hci_event.c:6157 hci_event_packet() assignment assumes 'hdev->sent_cmd->len' is '3' bytes
> >
> > Also these warnings are probably worth looking into:
> >
> > net/bluetooth/hci_event.c:3823 hci_num_comp_pkts_evt() warn: uncapped user loop: 'ev->num_hndl'
> > net/bluetooth/hci_event.c:3912 hci_num_comp_blocks_evt() warn: uncapped user loop: 'ev->num_hndl'
> > net/bluetooth/hci_event.c:5656 hci_le_adv_report_evt() warn: uncapped user loop: 'num_reports--'
> > net/bluetooth/hci_event.c:5726 hci_le_ext_adv_report_evt() warn: uncapped user loop: 'num_reports--'



-- 
Luiz Augusto von Dentz
