Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEA46D8AE
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhLHQnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:43:49 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56556 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234749AbhLHQnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:43:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D7A15CE2208;
        Wed,  8 Dec 2021 16:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91DCC00446;
        Wed,  8 Dec 2021 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638981614;
        bh=7zZtSP3/o+VvJNUh7Cp+bPLomI4Y1Y93T1f3X93UiMw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FFXMRlA5znMiDjoZcJY36ooQUjmDSgMwFYy9MrSMnCAQ8YGwSryVjFUU0wTP8sSuU
         0IcawRfdfy/iuZPa05RqIWW4M6UUtfa1mX/AaSUL4/ZcK+b12Mv3kZVYM2CDHLEFwJ
         Rhrev16Ib7DtdTDmlakCf8VDkwUV4+fKiEe84H2YB3Rhgsx4F1nm15pPxFce2dUPaL
         P7FMYDz9zmiufrgWptCiEZ6KieuJqWqwRI2Q20hg7mBQXcPItz8KqKlm2t5Fd8qbxW
         ilXr+jajhlT1Z8ka0k+wNxyOeO9l6EVvYnVuOLkvIV8Xq8o74l9dRCSubrCHV86Szi
         xnCswX/C6z9Sw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Luciano Coelho <luca@coelho.fi>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: pull-request: wireless-drivers-next-2021-12-07
References: <20211207144211.A9949C341C1@smtp.kernel.org>
        <20211207211412.13c78ace@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87tufjfrw0.fsf@codeaurora.org>
        <20211208065025.7060225d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87zgpb83uz.fsf@codeaurora.org>
Date:   Wed, 08 Dec 2021 18:40:08 +0200
In-Reply-To: <87zgpb83uz.fsf@codeaurora.org> (Kalle Valo's message of "Wed, 08
        Dec 2021 18:21:08 +0200")
Message-ID: <87v8zz82zb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

>> For the code we merge directly we try to make sure there are no new
>> warnings. I realize it's quite a bit of work for larger trees unless 
>> you have the infra so not a hard requirement (for you).
>
> Yeah, at the moment I really would not be able to catch W=1 or sparse
> warnings :/ And fixing them afterwards is just too slow. But if we would
> be able to fix all the warnings in drivers/net/wireless then it would be
> easy for me to enable W=1 and C=1 in my own build tests.

Actually for me to enable W=1 doesn't look so bad, the list is below.
Anyone want to fix these? Looks like roughly half of them is the
gnu_printf warning.

In function 'init_startup_params',
    inlined from 'ray_init' at drivers/net/wireless/ray_cs.c:500:2:
drivers/net/wireless/ray_cs.c:622:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
  622 |                 strncpy(local->sparm.b4.a_current_ess_id, essid, ESSID_SIZE);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/ipw2x00/ipw2100.c:6533: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Initialize the ipw2100 driver/module
drivers/net/wireless/intel/ipw2x00/ipw2100.c:6565: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Cleanup ipw2100 driver registration
In function 'prism2_ioctl_get_encryption',
    inlined from 'prism2_ioctl_priv_hostapd' at drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3801:9:
drivers/net/wireless/intersil/hostap/hostap_ioctl.c:3599:17: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
 3599 |                 strncpy(param->u.crypt.alg, (*crypt)->ops->name,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 3600 |                         HOSTAP_CRYPT_ALG_NAME_LEN);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/ops.c:270: warning: Function parameter or member 'min_size' not described in 'iwl_rx_handlers'
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:2392:5: warning: no previous prototype for 'mt7915_mcu_set_fixed_rate' [-Wmissing-prototypes]
 2392 | int mt7915_mcu_set_fixed_rate(struct mt7915_dev *dev,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~
In file included from ./include/trace/define_trace.h:102,
                 from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:137,
                 from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_err':
./include/trace/trace_events.h:727:16: warning: function 'trace_event_raw_event_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
  727 |         struct trace_event_raw_##call *entry;                           \
      |                ^~~~~~~~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
   31 | TRACE_EVENT(brcmf_err,
      | ^~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'trace_event_raw_event_brcmf_dbg':
./include/trace/trace_events.h:727:16: warning: function 'trace_event_raw_event_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
  727 |         struct trace_event_raw_##call *entry;                           \
      |                ^~~~~~~~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:47:1: note: in expansion of macro 'TRACE_EVENT'
   47 | TRACE_EVENT(brcmf_dbg,
      | ^~~~~~~~~~~
In file included from ./include/trace/define_trace.h:103,
                 from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h:137,
                 from drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:12:
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_err':
./include/trace/perf.h:41:16: warning: function 'perf_trace_brcmf_err' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
   41 |         struct hlist_head *head;                                        \
      |                ^~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:31:1: note: in expansion of macro 'TRACE_EVENT'
   31 | TRACE_EVENT(brcmf_err,
      | ^~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h: In function 'perf_trace_brcmf_dbg':
./include/trace/perf.h:41:16: warning: function 'perf_trace_brcmf_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
   41 |         struct hlist_head *head;                                        \
      |                ^~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmfmac/./tracepoint.h:47:1: note: in expansion of macro 'TRACE_EVENT'
   47 | TRACE_EVENT(brcmf_dbg,
      | ^~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/debugfs.c: In function 'mt76_rx_queues_read':
drivers/net/wireless/mediatek/mt76/debugfs.c:77:16: warning: variable 'queued' set but not used [-Wunused-but-set-variable]
   77 |         int i, queued;
      |                ^~~~~~
In file included from drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:14:
drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h:39:37: warning: 'iwl_dbgfs_dbg_time_point_ops' defined but not used [-Wunused-const-variable=]
   39 | static const struct file_operations iwl_dbgfs_##name##_ops = {          \
      |                                     ^~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1548:9: note: in expansion of macro '_MVM_DEBUGFS_WRITE_FILE_OPS'
 1548 |         _MVM_DEBUGFS_WRITE_FILE_OPS(name, bufsz, struct iwl_mvm)
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1867:1: note: in expansion of macro 'MVM_DEBUGFS_WRITE_FILE_OPS'
 1867 | MVM_DEBUGFS_WRITE_FILE_OPS(dbg_time_point, 64);
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:11: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * DDR needs frequency in units of 16.666MHz, so provide FW with the
In file included from ./include/trace/define_trace.h:102,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:86,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
./drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'trace_event_raw_event_brcms_dbg':
./include/trace/trace_events.h:727:16: warning: function 'trace_event_raw_event_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
  727 |         struct trace_event_raw_##call *entry;                           \
      |                ^~~~~~~~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:61:1: note: in expansion of macro 'TRACE_EVENT'
   61 | TRACE_EVENT(brcms_dbg,
      | ^~~~~~~~~~~
In file included from ./include/trace/define_trace.h:103,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h:86,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.h:38,
                 from drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_events.c:22:
./drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h: In function 'perf_trace_brcms_dbg':
./include/trace/perf.h:41:16: warning: function 'perf_trace_brcms_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
   41 |         struct hlist_head *head;                                        \
      |                ^~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
./drivers/net/wireless/broadcom/brcm80211/brcmsmac/./brcms_trace_brcmsmac_msg.h:61:1: note: in expansion of macro 'TRACE_EVENT'
   61 | TRACE_EVENT(brcms_dbg,
      | ^~~~~~~~~~~
drivers/net/wireless/marvell/mwifiex/pcie.c: In function 'mwifiex_pm_wakeup_card':
drivers/net/wireless/marvell/mwifiex/pcie.c:659:13: warning: variable 'retval' set but not used [-Wunused-but-set-variable]
  659 |         int retval;
      |             ^~~~~~
In file included from ./include/trace/define_trace.h:102,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h:75,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:91,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c:15:
drivers/net/wireless/intel/iwlwifi/./iwl-devtrace-msg.h: In function 'trace_event_raw_event_iwlwifi_dbg':
./include/trace/trace_events.h:727:16: warning: function 'trace_event_raw_event_iwlwifi_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
  727 |         struct trace_event_raw_##call *entry;                           \
      |                ^~~~~~~~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/./iwl-devtrace-msg.h:51:1: note: in expansion of macro 'TRACE_EVENT'
   51 | TRACE_EVENT(iwlwifi_dbg,
      | ^~~~~~~~~~~
In file included from ./include/trace/define_trace.h:103,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h:75,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:91,
                 from drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c:15:
drivers/net/wireless/intel/iwlwifi/./iwl-devtrace-msg.h: In function 'perf_trace_iwlwifi_dbg':
./include/trace/perf.h:41:16: warning: function 'perf_trace_iwlwifi_dbg' might be a candidate for 'gnu_printf' format attribute [-Wsuggest-attribute=format]
   41 |         struct hlist_head *head;                                        \
      |                ^~~~~~~~~~
./include/trace/trace_events.h:75:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
   75 |         DECLARE_EVENT_CLASS(name,                              \
      |         ^~~~~~~~~~~~~~~~~~~
drivers/net/wireless/intel/iwlwifi/./iwl-devtrace-msg.h:51:1: note: in expansion of macro 'TRACE_EVENT'
   51 | TRACE_EVENT(iwlwifi_dbg,
      | ^~~~~~~~~~~


-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
