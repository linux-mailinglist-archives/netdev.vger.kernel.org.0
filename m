Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12E143EA9EB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbhHLSHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhHLSH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 14:07:29 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF9C061756;
        Thu, 12 Aug 2021 11:07:03 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id c5so380405ybn.5;
        Thu, 12 Aug 2021 11:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v/ZIQda58F/GXonfyitBlnxjAa7bu/RGEkUZMUU4FQ8=;
        b=Ik1t3PfRsXqB/kml83byWnsCDNYAI7ZM+gq5vk2CljphYddlAXpJMcXDJAMp4GlhLK
         KyeFVB2NZTWtvtZWWQUBtXQ5UQVURfM2bxYDikoEXExaucLKXwDemXFaKXVFEyGQIK5L
         jh6mif+STi3naknobM7tgJkF7fq6SqQ2ddsC9fLfjLZZvlma9IG86LVY84v9Z5tiBU6U
         PA7BPCwPOZaKo12OT3SU6i1IuLE+DdEo9AzJ9G61TNb0bE9YLkAcaR5A1t+LdXw0dqAu
         4S6JhR8Po+S4rOJwhrHm7KZttHdOaFV95GVQ5cBYWoUdl9bhh4oz9jZsGOggOIj/aKDI
         zAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v/ZIQda58F/GXonfyitBlnxjAa7bu/RGEkUZMUU4FQ8=;
        b=d5l0rj/DduGLWZmV2ZzGIcFw0DjTHP/AiY5QX4skmhz1D7k4MQN63v/mDyYNf3dNrE
         91fC5pruiOWg+SgPHQtk3ttgSnl4NG0K3YM/AwmhRD7ArDME6OGDP9TzXIP4j2GP60pu
         wIOQd6hEnwLTbcE9cLI+4dxgbkI5180O8V62diM/8DKLEEUdbHzYN5aMNl/yZWpAwIwo
         5aPnUOih4OP6bs6dwlLNdak2glvowZaRPgxtRP5b7zA5jZf1F2WJfdPhCiJ8/VDhIjYQ
         pcAQ6sh14SyAITtIeDTQr4FuYuWy9faGQYrEQq2jo0SCa7Z+P5/Ah9P7CfpW8yni/flA
         uPvg==
X-Gm-Message-State: AOAM530qEpVSVLftlIQCQXCnJTUWZZqfeAYI7cKBH3eQDzAGsjz64GhM
        RmDMViiEgNEBsk44E3ycNpOO+MiAIKoISiaqthE=
X-Google-Smtp-Source: ABdhPJyk/P9T/CTZQaTpG5PMBm5Mjlnnulj+SOKCP08ov221u6MCgJK+/k6TuirHQW181s5/+DKj283DmQckm3SxyPI=
X-Received: by 2002:a25:9b03:: with SMTP id y3mr5708965ybn.264.1628791622828;
 Thu, 12 Aug 2021 11:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210812171533.v7.1.I41aec59e65ffd3226d368dabeb084af13cc133c8@changeid>
 <20210812171533.v7.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
In-Reply-To: <20210812171533.v7.4.I20c79eef4f36c4a3802e1068e59ec4a9f4ded940@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 12 Aug 2021 11:06:52 -0700
Message-ID: <CABBYNZLPe6TkQkyjZW2sdvOkWGb-K16Wgbc-rbpG6h3ACxaMqg@mail.gmail.com>
Subject: Re: [PATCH v7 4/4] Bluetooth: Support the quality report events
To:     Joseph Hwang <josephsih@chromium.org>
Cc:     "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Joseph Hwang <josephsih@google.com>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joseph,

On Thu, Aug 12, 2021 at 2:16 AM Joseph Hwang <josephsih@chromium.org> wrote:
>
> This patch allows a user space process to enable/disable the quality
> report events dynamically through the set experimental feature mgmt
> interface if CONFIG_BT_FEATURE_QUALITY_REPORT is enabled.
>
> Since the quality report feature needs to invoke the callback function
> provided by the driver, i.e., hdev->set_quality_report, a valid
> controller index is required.
>
> Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
> Signed-off-by: Joseph Hwang <josephsih@chromium.org>
> ---
>
> Changes in v7:
> - Rebase on Tedd's patches that moved functionality from btusb to
>   btintel.
>
> Changes in v5:
> - Removed CONFIG_BT_FEATURE_QUALITY_REPORT since there was no
>   large size impact.
>
>  include/net/bluetooth/hci.h      |   1 +
>  include/net/bluetooth/hci_core.h |   2 +
>  net/bluetooth/mgmt.c             | 110 ++++++++++++++++++++++++++++++-
>  3 files changed, 112 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index b80415011dcd..bb6b7398f490 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -330,6 +330,7 @@ enum {
>         HCI_ENABLE_LL_PRIVACY,
>         HCI_CMD_PENDING,
>         HCI_FORCE_NO_MITM,
> +       HCI_QUALITY_REPORT,

Hmm, 3/4 actually makes use of HCI_QUALITY_REPORT so this should
actually appear before it (3/4 4/4 should be swapped) otherwise we
break the likes of bisect, I usually recommend using git rebase -i
origin/master --exec make to check if each and every change build
properly.

>
>         __HCI_NUM_FLAGS,
>  };
> diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> index a7d06d7da602..7e9ae36b2582 100644
> --- a/include/net/bluetooth/hci_core.h
> +++ b/include/net/bluetooth/hci_core.h
> @@ -606,6 +606,7 @@ struct hci_dev {
>         int (*set_bdaddr)(struct hci_dev *hdev, const bdaddr_t *bdaddr);
>         void (*cmd_timeout)(struct hci_dev *hdev);
>         bool (*prevent_wake)(struct hci_dev *hdev);
> +       int (*set_quality_report)(struct hci_dev *hdev, bool enable);
>  };
>
>  #define HCI_PHY_HANDLE(handle) (handle & 0xff)
> @@ -759,6 +760,7 @@ extern struct mutex hci_cb_list_lock;
>                 hci_dev_clear_flag(hdev, HCI_LE_ADV);           \
>                 hci_dev_clear_flag(hdev, HCI_LL_RPA_RESOLUTION);\
>                 hci_dev_clear_flag(hdev, HCI_PERIODIC_INQ);     \
> +               hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);   \
>         } while (0)
>
>  /* ----- HCI interface to upper protocols ----- */
> diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
> index 1e21e014efd2..358250862720 100644
> --- a/net/bluetooth/mgmt.c
> +++ b/net/bluetooth/mgmt.c
> @@ -3791,6 +3791,12 @@ static const u8 debug_uuid[16] = {
>  };
>  #endif
>
> +/* 330859bc-7506-492d-9370-9a6f0614037f */
> +static const u8 quality_report_uuid[16] = {
> +       0x7f, 0x03, 0x14, 0x06, 0x6f, 0x9a, 0x70, 0x93,
> +       0x2d, 0x49, 0x06, 0x75, 0xbc, 0x59, 0x08, 0x33,
> +};
> +
>  /* 671b10b5-42c0-4696-9227-eb28d1b049d6 */
>  static const u8 simult_central_periph_uuid[16] = {
>         0xd6, 0x49, 0xb0, 0xd1, 0x28, 0xeb, 0x27, 0x92,
> @@ -3806,7 +3812,7 @@ static const u8 rpa_resolution_uuid[16] = {
>  static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
>                                   void *data, u16 data_len)
>  {
> -       char buf[62];   /* Enough space for 3 features */
> +       char buf[82];   /* Enough space for 4 features: 2 + 20 * 4 */
>         struct mgmt_rp_read_exp_features_info *rp = (void *)buf;
>         u16 idx = 0;
>         u32 flags;
> @@ -3850,6 +3856,24 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
>                 idx++;
>         }
>
> +       if (hdev) {
> +               if (hdev->set_quality_report) {
> +                       /* BIT(0): indicating if set_quality_report is
> +                        * supported by controller.
> +                        */
> +                       flags = BIT(0);
> +
> +                       /* BIT(1): indicating if the feature is enabled. */
> +                       if (hci_dev_test_flag(hdev, HCI_QUALITY_REPORT))
> +                               flags |= BIT(1);
> +               } else {
> +                       flags = 0;
> +               }
> +               memcpy(rp->features[idx].uuid, quality_report_uuid, 16);
> +               rp->features[idx].flags = cpu_to_le32(flags);
> +               idx++;
> +       }
> +
>         rp->feature_count = cpu_to_le16(idx);
>
>         /* After reading the experimental features information, enable
> @@ -3892,6 +3916,21 @@ static int exp_debug_feature_changed(bool enabled, struct sock *skip)
>  }
>  #endif
>
> +static int exp_quality_report_feature_changed(bool enabled, struct sock *skip)
> +{
> +       struct mgmt_ev_exp_feature_changed ev;
> +
> +       BT_INFO("enabled %d", enabled);
> +
> +       memset(&ev, 0, sizeof(ev));
> +       memcpy(ev.uuid, quality_report_uuid, 16);
> +       ev.flags = cpu_to_le32(enabled ? BIT(0) : 0);
> +
> +       return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, NULL,
> +                                 &ev, sizeof(ev),
> +                                 HCI_MGMT_EXP_FEATURE_EVENTS, skip);
> +}
> +
>  static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
>                            void *data, u16 data_len)
>  {
> @@ -4038,6 +4077,75 @@ static int set_exp_feature(struct sock *sk, struct hci_dev *hdev,
>                 return err;
>         }

Perhaps it would be a good idea to have a function table e.g:

struct mgmt_exp_feature {
  const char *uuid;
  int (func*)(...)
} exp_features[] = {
...
};

That way we don't have to add such changes directly into
set_exp_feature just in the table and implement its callback.

> +       if (!memcmp(cp->uuid, quality_report_uuid, 16)) {
> +               bool val, changed;
> +               int err;
> +
> +               /* Command requires to use a valid controller index */
> +               if (!hdev)
> +                       return mgmt_cmd_status(sk, MGMT_INDEX_NONE,
> +                                              MGMT_OP_SET_EXP_FEATURE,
> +                                              MGMT_STATUS_INVALID_INDEX);
> +
> +               /* Parameters are limited to a single octet */
> +               if (data_len != MGMT_SET_EXP_FEATURE_SIZE + 1)
> +                       return mgmt_cmd_status(sk, hdev->id,
> +                                              MGMT_OP_SET_EXP_FEATURE,
> +                                              MGMT_STATUS_INVALID_PARAMS);
> +
> +               /* Only boolean on/off is supported */
> +               if (cp->param[0] != 0x00 && cp->param[0] != 0x01)
> +                       return mgmt_cmd_status(sk, hdev->id,
> +                                              MGMT_OP_SET_EXP_FEATURE,
> +                                              MGMT_STATUS_INVALID_PARAMS);
> +
> +               hci_req_sync_lock(hdev);
> +
> +               val = !!cp->param[0];
> +               changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
> +
> +               if (!hdev->set_quality_report) {
> +                       BT_INFO("quality report not supported");
> +                       err = mgmt_cmd_status(sk, hdev->id,
> +                                             MGMT_OP_SET_EXP_FEATURE,
> +                                             MGMT_STATUS_NOT_SUPPORTED);
> +                       goto unlock_quality_report;
> +               }
> +
> +               if (changed) {
> +                       err = hdev->set_quality_report(hdev, val);
> +                       if (err) {
> +                               BT_ERR("set_quality_report value %d err %d",
> +                                      val, err);
> +                               err = mgmt_cmd_status(sk, hdev->id,
> +                                                     MGMT_OP_SET_EXP_FEATURE,
> +                                                     MGMT_STATUS_FAILED);
> +                               goto unlock_quality_report;
> +                       }
> +                       if (val)
> +                               hci_dev_set_flag(hdev, HCI_QUALITY_REPORT);
> +                       else
> +                               hci_dev_clear_flag(hdev, HCI_QUALITY_REPORT);
> +               }
> +
> +               BT_INFO("quality report enable %d changed %d",
> +                       val, changed);
> +
> +               memcpy(rp.uuid, quality_report_uuid, 16);
> +               rp.flags = cpu_to_le32(val ? BIT(0) : 0);
> +               hci_sock_set_flag(sk, HCI_MGMT_EXP_FEATURE_EVENTS);
> +               err = mgmt_cmd_complete(sk, hdev->id,
> +                                       MGMT_OP_SET_EXP_FEATURE, 0,
> +                                       &rp, sizeof(rp));
> +
> +               if (changed)
> +                       exp_quality_report_feature_changed(val, sk);
> +
> +unlock_quality_report:
> +               hci_req_sync_unlock(hdev);
> +               return err;
> +       }
> +
>         return mgmt_cmd_status(sk, hdev ? hdev->id : MGMT_INDEX_NONE,
>                                MGMT_OP_SET_EXP_FEATURE,
>                                MGMT_STATUS_NOT_SUPPORTED);
> --
> 2.32.0.605.g8dce9f2422-goog
>


-- 
Luiz Augusto von Dentz
