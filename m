Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B73B016D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 12:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhFVKfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 06:35:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:1536 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229849AbhFVKfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 06:35:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MAQHH0029512;
        Tue, 22 Jun 2021 10:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=f32BjBIPya71fK3RbGqZYsILwG+PUKV3aYsCn5KnU6g=;
 b=WpHINYHVgdyk//A7RkXseZziWDLQ3iCcheSGJtM3kU86iV5oAU0p0x+Z5i5Ut9Ll/Hat
 imaKdTq+Xu1/+yH0EoDKc1VQU3C8N7jiNpYheRY7xSEUR3rd0yB/8zaJqXE8XLkH6rmf
 P6KFohUefTxNZdUJ6r6Th+qs+IDwplXVEsFY8qJGcWaIX5qeV2NGXrhPzi7W9t0YGfGt
 09jSZRHcSCx2VuoLQWaTMp99fvb4KP6UtmhpW23CxlkTlGAgGtnkDudmqkKWI3lGH6ck
 APaQvUVgsYYUaAqLKYCZYfz9bLeTHDuFd8s25PaTzRkNdCR0HSlMa+9j1zOTri6dwMWK IA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39acyqbm23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 10:32:46 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15MARcBe024272;
        Tue, 22 Jun 2021 10:32:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 399tbsbxgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 10:32:45 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15MAWi7t043145;
        Tue, 22 Jun 2021 10:32:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 399tbsbxff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 10:32:44 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15MAWecs029075;
        Tue, 22 Jun 2021 10:32:40 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 03:32:39 -0700
Date:   Tue, 22 Jun 2021 13:32:32 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Lin Horse <kylin.formalin@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Greg KH <greg@kroah.com>, security@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: OOB Read in hci_cc_read_local_name() cause information leak
Message-ID: <20210622103232.GL1901@kadam>
References: <CAJjojJvCv2aMWt_cjSC2eBNBDGwV2ottSApgmHdJmup6-+_k4w@mail.gmail.com>
 <YKc6SloWBg5maJpU@kroah.com>
 <CAJjojJtvYeK4N7E8MZkF8YBbp-mvjzoeJgjb=6zQB6h-5tRkNg@mail.gmail.com>
 <20210521090256.GA24442@kadam>
 <CAJjojJu6ZaAZOs1K=OsvA0=+ZNVATdT3YgbsqSzTYeFJFCgqzQ@mail.gmail.com>
 <20210521150454.GD24442@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521150454.GD24442@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: fspK4l2yTwxkMeNGJcee2P0jOfHB3edN
X-Proofpoint-ORIG-GUID: fspK4l2yTwxkMeNGJcee2P0jOfHB3edN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

I was looking through old bug reports that Lin Horse had reported and
was wondering when your patchset would be applied?

https://lore.kernel.org/linux-bluetooth/20210419171257.3865181-1-luiz.dentz@gmail.com/

I really like the hci_skb_pull() function and I think that it should be
made into a top level function which all drivers can use.  It's like
skb_pull() but it returns the old skb->data instead of skb->data + len.
The skb_pull() still updates skb->data and skb->len.

static void *skb_pull_data(struct sk_buff *skb, size_t len)
{
	void *data = skb->data;

	if (skb->len < len)
		return NULL;

	skb_pull(skb, len);

	return data;
}

There is a lot of code that does "struct foo *p = (void *)skb->data;"
and that's hard to audit and error prone.  Changing it to:

	p = skb_pull_data(skb, sizeof(*p));
	if (!p)
		return;

seems more clear and safe.

regards,
dan carpenter

> net/bluetooth/hci_event.c:119 hci_cc_role_discovery() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:138 hci_cc_read_link_policy() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:157 hci_cc_write_link_policy() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:182 hci_cc_read_def_link_policy() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:246 hci_cc_read_stored_link_key() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:264 hci_cc_delete_stored_link_key() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:300 hci_cc_read_local_name() assignment assumes 'skb->len' is '249' bytes
> net/bluetooth/hci_event.c:423 hci_cc_read_class_of_dev() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:460 hci_cc_read_voice_setting() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:513 hci_cc_read_num_supported_iac() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:589 hci_cc_read_local_version() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:609 hci_cc_read_local_commands() assignment assumes 'skb->len' is '65' bytes
> net/bluetooth/hci_event.c:624 hci_cc_read_auth_payload_timeout() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:644 hci_cc_write_auth_payload_timeout() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:669 hci_cc_read_local_features() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:719 hci_cc_read_local_ext_features() assignment assumes 'skb->len' is '11' bytes
> net/bluetooth/hci_event.c:736 hci_cc_read_flow_control_mode() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:748 hci_cc_read_buffer_size() assignment assumes 'skb->len' is '8' bytes
> net/bluetooth/hci_event.c:774 hci_cc_read_bd_addr() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:791 hci_cc_read_local_pairing_opts() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:808 hci_cc_read_page_scan_activity() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:843 hci_cc_read_page_scan_type() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:873 hci_cc_read_data_block_size() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:892 hci_cc_read_clock() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:928 hci_cc_read_local_amp_info() assignment assumes 'skb->len' is '31' bytes
> net/bluetooth/hci_event.c:950 hci_cc_read_inq_rsp_tx_power() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:963 hci_cc_read_def_err_data_reporting() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:993 hci_cc_pin_code_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1021 hci_cc_pin_code_neg_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1037 hci_cc_le_read_buffer_size() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:1055 hci_cc_le_read_local_features() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:1068 hci_cc_le_read_adv_tx_power() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:1080 hci_cc_user_confirm_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1096 hci_cc_user_confirm_neg_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1111 hci_cc_user_passkey_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1127 hci_cc_user_passkey_neg_reply() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:1143 hci_cc_read_local_oob_data() assignment assumes 'skb->len' is '33' bytes
> net/bluetooth/hci_event.c:1151 hci_cc_read_local_oob_ext_data() assignment assumes 'skb->len' is '65' bytes
> net/bluetooth/hci_event.c:1230 hci_cc_le_read_transmit_power() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:1484 hci_cc_le_read_num_adv_sets() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:1498 hci_cc_le_read_white_list_size() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:1562 hci_cc_le_read_supported_states() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:1575 hci_cc_le_read_def_data_len() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:1660 hci_cc_le_read_resolv_list_size() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:1697 hci_cc_le_read_max_data_len() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:1765 hci_cc_set_ext_adv_param() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:1796 hci_cc_read_rssi() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:1816 hci_cc_read_tx_power() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:2607 hci_conn_complete_evt() assignment assumes 'skb->len' is '11' bytes
> net/bluetooth/hci_event.c:2731 hci_conn_request_evt() assignment assumes 'skb->len' is '10' bytes
> net/bluetooth/hci_event.c:2842 hci_disconn_complete_evt() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:2934 hci_auth_complete_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:3004 hci_remote_name_evt() assignment assumes 'skb->len' is '255' bytes
> net/bluetooth/hci_event.c:3087 hci_encrypt_change_evt() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:3202 hci_change_link_key_complete_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:3225 hci_remote_features_evt() assignment assumes 'skb->len' is '11' bytes
> net/bluetooth/hci_event.c:3293 hci_cmd_complete_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:3670 hci_cmd_status_evt() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:3776 hci_hardware_error_evt() assignment assumes 'skb->len' is '1' bytes
> net/bluetooth/hci_event.c:3785 hci_role_change_evt() assignment assumes 'skb->len' is '8' bytes
> net/bluetooth/hci_event.c:3807 hci_num_comp_pkts_evt() assignment assumes 'skb->len' is '1' bytes
> net/bluetooth/hci_event.c:3895 hci_num_comp_blocks_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:3946 hci_mode_change_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:3974 hci_pin_code_request_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:4044 hci_link_key_request_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:4104 hci_link_key_notify_evt() assignment assumes 'skb->len' is '23' bytes
> net/bluetooth/hci_event.c:4164 hci_clock_offset_evt() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:4187 hci_pkt_type_change_evt() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:4203 hci_pscan_rep_mode_evt() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:4293 hci_remote_ext_features_evt() assignment assumes 'skb->len' is '13' bytes
> net/bluetooth/hci_event.c:4357 hci_sync_conn_complete_evt() assignment assumes 'skb->len' is '17' bytes
> net/bluetooth/hci_event.c:4505 hci_key_refresh_complete_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:4614 hci_io_capa_request_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:4683 hci_io_capa_reply_evt() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:4704 hci_user_confirm_request_evt() assignment assumes 'skb->len' is '10' bytes
> net/bluetooth/hci_event.c:4789 hci_user_passkey_request_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:4800 hci_user_passkey_notify_evt() assignment assumes 'skb->len' is '10' bytes
> net/bluetooth/hci_event.c:4820 hci_keypress_notify_evt() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:4859 hci_simple_pair_complete_evt() assignment assumes 'skb->len' is '7' bytes
> net/bluetooth/hci_event.c:4890 hci_remote_host_features_evt() assignment assumes 'skb->len' is '14' bytes
> net/bluetooth/hci_event.c:4912 hci_remote_oob_data_request_evt() assignment assumes 'skb->len' is '6' bytes
> net/bluetooth/hci_event.c:4966 hci_chan_selected_evt() assignment assumes 'skb->len' is '1' bytes
> net/bluetooth/hci_event.c:4983 hci_phy_link_complete_evt() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:5023 hci_loglink_complete_evt() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:5063 hci_disconn_loglink_complete_evt() assignment assumes 'skb->len' is '4' bytes
> net/bluetooth/hci_event.c:5087 hci_disconn_phylink_complete_evt() assignment assumes 'skb->len' is '3' bytes
> net/bluetooth/hci_event.c:5271 hci_le_conn_complete_evt() assignment assumes 'skb->len' is '18' bytes
> net/bluetooth/hci_event.c:5285 hci_le_enh_conn_complete_evt() assignment assumes 'skb->len' is '30' bytes
> net/bluetooth/hci_event.c:5303 hci_le_ext_adv_term_evt() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:5332 hci_le_conn_update_complete_evt() assignment assumes 'skb->len' is '9' bytes
> net/bluetooth/hci_event.c:5749 hci_le_remote_feat_complete_evt() assignment assumes 'skb->len' is '11' bytes
> net/bluetooth/hci_event.c:5790 hci_le_ltk_request_evt() assignment assumes 'skb->len' is '12' bytes
> net/bluetooth/hci_event.c:5867 hci_le_remote_conn_param_req_evt() assignment assumes 'skb->len' is '10' bytes
> net/bluetooth/hci_event.c:5944 hci_le_phy_update_evt() assignment assumes 'skb->len' is '5' bytes
> net/bluetooth/hci_event.c:5967 hci_le_meta_evt() assignment assumes 'skb->len' is '1' bytes
> net/bluetooth/hci_event.c:6079 hci_store_wake_reason() assignment assumes 'skb->len' is '11' bytes
> net/bluetooth/hci_event.c:6080 hci_store_wake_reason() assignment assumes 'skb->len' is '10' bytes
> net/bluetooth/hci_event.c:6106 hci_store_wake_reason() assignment assumes 'skb->len' is '1' bytes
> net/bluetooth/hci_event.c:6144 hci_event_packet() assignment assumes 'skb->len' is '2' bytes
> net/bluetooth/hci_event.c:6157 hci_event_packet() assignment assumes 'hdev->sent_cmd->len' is '3' bytes
> 
> Also these warnings are probably worth looking into:
> 
> net/bluetooth/hci_event.c:3823 hci_num_comp_pkts_evt() warn: uncapped user loop: 'ev->num_hndl'
> net/bluetooth/hci_event.c:3912 hci_num_comp_blocks_evt() warn: uncapped user loop: 'ev->num_hndl'
> net/bluetooth/hci_event.c:5656 hci_le_adv_report_evt() warn: uncapped user loop: 'num_reports--'
> net/bluetooth/hci_event.c:5726 hci_le_ext_adv_report_evt() warn: uncapped user loop: 'num_reports--'
