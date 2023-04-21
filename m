Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB06EAD77
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbjDUOw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjDUOwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:52:55 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A35EB771;
        Fri, 21 Apr 2023 07:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=J9qyPU+PVnsNsWzTVs4DoiCRroFoofUuOFvtJinm82Q=; b=YRhhNtQVDz+1hX//XCxHP/YsIP
        9aAfbEclTj5/QSEk7AnKYOgmGBgADCYIyheaW8eJemBmSlEQ/2vSW5shnHyPr40uhHjhs1Y7yPj9X
        eXVO44Y187UjR54YHjwaSCNXHsAIAuXvc/nnWXKdvIl/3UoERRRBRJPwwtbfm7zgOPQx762hcbPM7
        UXTAamIUsT7dwHO32xHlzi6LsFKJbjB7qBtLfmeEt6ArG0mbfx6VDLPTMVKvaS4eP+BC9beqI0aDN
        eVF1lQCdtwgro4fzD2bBqdEuW7NcLgLmm+r9CLBW23p0KBpf5bgnj6HpICEWibmPRqyWRhzF9J/B5
        /xXEvWfA==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pps7r-000NGA-SA; Fri, 21 Apr 2023 16:52:39 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pps7r-000VNF-7l; Fri, 21 Apr 2023 16:52:39 +0200
Subject: Re: [xdp-hints] Re: [PATCH bpf-next V2 0/5] XDP-hints: XDP kfunc
 metadata for driver igc
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martin.lau@kernel.org" <martin.lau@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "Lobakin, Aleksander" <aleksander.lobakin@intel.com>,
        "Zaremba, Larysa" <larysa.zaremba@intel.com>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <168182460362.616355.14591423386485175723.stgit@firesoul>
 <PH0PR11MB583075A0520F8760657FC4BED89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f134a734-c67e-b546-b1ef-53da676acaf4@iogearbox.net>
Date:   Fri, 21 Apr 2023 16:52:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <PH0PR11MB583075A0520F8760657FC4BED89D9@PH0PR11MB5830.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26883/Fri Apr 21 09:25:39 2023)
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/23 4:53 PM, Song, Yoong Siang wrote:
> On Tuesday, April 18, 2023 9:31 PM, Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>> Implement both RX hash and RX timestamp XDP hints kfunc metadata for driver
>> igc.
>>
>> First patch fix RX hashing for igc in general.
>>
>> Last patch change test program xdp_hw_metadata to track more timestamps,
>> which helps us correlate the hardware RX timestamp with something.
>>
>> ---
>> To maintainers: I'm uncertain which git tree this should be sent against. This is
>> primary NIC driver code (net-next), but it's BPF/XDP related (bpf-next) via
>> xdp_metadata_ops.
>>
>> Jesper Dangaard Brouer (5):
>>       igc: enable and fix RX hash usage by netstack
>>       igc: add igc_xdp_buff wrapper for xdp_buff in driver
>>       igc: add XDP hints kfuncs for RX hash
>>       igc: add XDP hints kfuncs for RX timestamp
>>       selftests/bpf: xdp_hw_metadata track more timestamps
>>
>>
>> drivers/net/ethernet/intel/igc/igc.h          |  35 ++++++
>> drivers/net/ethernet/intel/igc/igc_main.c     | 116 ++++++++++++++++--
>> .../selftests/bpf/progs/xdp_hw_metadata.c     |   4 +-
>> tools/testing/selftests/bpf/xdp_hw_metadata.c |  47 ++++++-
>> tools/testing/selftests/bpf/xdp_metadata.h    |   1 +
>> 5 files changed, 186 insertions(+), 17 deletions(-)
>>
>> --
> 
> This patchset lgtm.
> Thanks for the changes.

Siang, can I take this into the patches as your:

Acked-by: Song Yoong Siang <yoong.siang.song@intel.com>

?

Thanks,
Daniel
