Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914E7553824
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353508AbiFUQpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353507AbiFUQpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:45:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9E727147
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 09:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655829903; x=1687365903;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z3Kav+3i5bE9VOAbzNtPi6jxYc8m18IeZBQMGg7dcak=;
  b=B74g6f8vG0XqhZMmJIyAiRpEc9vH1dvfLhswlZiP20Ce3aqnR4V7HzJt
   stE/LHqw5ucnOxp9+jEgtplOk3p7mnDSsYGggpLQo+m9g5ikLRSoVwHmV
   SqXd6QfqtiL4MsGq2QZpQLgXYBB/BiZWu7YlkKPk2FECAqXrM6bieMXDp
   Ad2A9cf3DhteZzAnB4/59vym5+7yA7Zja3ZZbzH1v3wzxCzc8Jxj7KflD
   JWk0Io/x2XHjom8HGKvsX0k8ZVbbc6bkO9yVIxZkGwXp4jCZsagFRlK74
   CV3Jgzb5RXWi3mEIl0FlI+Tp+4Vc4RRCYTJOTSGDPmJVu7B8rsBcCg0j0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="366490641"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="366490641"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 09:45:03 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="690021027"
Received: from chenjas1-mobl.amr.corp.intel.com (HELO [10.251.15.59]) ([10.251.15.59])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 09:45:02 -0700
Message-ID: <45113752-c6a6-a578-3a5a-575d2348d856@linux.intel.com>
Date:   Tue, 21 Jun 2022 09:45:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS port
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <20220614205756.6792-1-moises.veleta@linux.intel.com>
 <CAMZdPi8cdgDUtDN=Oqz7Po+_XsKS=tRmx-Hg=_Mix9ftKQ5b3A@mail.gmail.com>
 <566dc410-458e-8aff-7839-d568e55f9ff3@linux.intel.com>
 <CAHNKnsRaOS54c6K_s5JmmgDP2KEV38XpGWY5eAmQJ-EUnQt4Ww@mail.gmail.com>
From:   "moises.veleta" <moises.veleta@linux.intel.com>
In-Reply-To: <CAHNKnsRaOS54c6K_s5JmmgDP2KEV38XpGWY5eAmQJ-EUnQt4Ww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/18/22 04:55, Sergey Ryazanov wrote:
> Hello Moises,
>
> On Fri, Jun 17, 2022 at 8:28 PM moises.veleta
> <moises.veleta@linux.intel.com> wrote:
>> On 6/16/22 10:29, Loic Poulain wrote:
>>> Hi Moises,
>>>
>>> On Tue, 14 Jun 2022 at 22:58, Moises Veleta
>>> <moises.veleta@linux.intel.com> wrote:
>>>> From: Haijun Liu <haijun.liu@mediatek.com>
>>>>
>>>> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
>>>> communicate with AP and Modem processors respectively. So far only
>>>> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
>>>> port which requires such channel.
>>>>
>>>> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
>>>> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
>>>> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
>>>> ---
>>> [...]
>>>>    static const struct t7xx_port_conf t7xx_md_port_conf[] = {
>>>>           {
>>>> +               .tx_ch = PORT_CH_AP_GNSS_TX,
>>>> +               .rx_ch = PORT_CH_AP_GNSS_RX,
>>>> +               .txq_index = Q_IDX_CTRL,
>>>> +               .rxq_index = Q_IDX_CTRL,
>>>> +               .path_id = CLDMA_ID_AP,
>>>> +               .ops = &wwan_sub_port_ops,
>>>> +               .name = "t7xx_ap_gnss",
>>>> +               .port_type = WWAN_PORT_AT,
>>> Is it really AT protocol here? wouldn't it be possible to expose it
>>> via the existing GNSS susbsystem?
>> The protocol is AT.
>> It is not possible to using the GNSS subsystem as it is meant for
>> stand-alone GNSS receivers without a control path. In this case, GNSS
>> can used for different use cases, such as Assisted GNSS, Cell ID
>> positioning, Geofence, etc. Hence, this requires the use of the AT
>> channel on the WWAN subsystem.
> To make it clear. When you talking about a control path, did you mean
> that this GNSS port is not a simple NMEA port? Or did you mean that
> this port is NMEA, but the user is required to activate GPS
> functionality using the separate AT-commands port?
>
> In other words, what is the format of the data that are transmitted
> over the GNSS port of the modem?
>
It is an AT port where MTK GNSS AT commands can be sent and received. 
Not a simple NMEA port, but NMEA data can be sent to Host via an AT 
command. Control port is exposed for Modem Manager to send GNSS comands, 
which may include disable/enable GPS functionality (enabled by default).

These are MTK GNSS AT commands, which follow the syntax as defined by 
3GPP TS 27.007.  These are not standard AT commands.


Regards,
Moises

