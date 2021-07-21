Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455553D1195
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238397AbhGUOE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:04:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48043 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232977AbhGUOEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:04:25 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 673005C00FB;
        Wed, 21 Jul 2021 10:45:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 21 Jul 2021 10:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=VIJjX4qnzM07h6oPuSQLR9MrrpMq7tOaSltZ/UKgW
        TA=; b=doNk0oumfeEHj0TcDX1Mm4zN6fkcb7NdAiUvin/sDulz8Xf+VNfjsjoGR
        +b/gl485DSlvZaIatEupyVhcu0EIidUAh9w3xe4e3yqngUvxXMG964BDNUbbHA46
        6U3sQwnbBnqnPV+3oPP+nGfH6TO9DLHNF6FfMXhXtY4l5MnImacymT6mU8U2AymS
        RxP0IxGCu6OMSMbRVXC8Mrnvo8ZBTzo6n5OCSPZfbR7PIg8id4eRk09kxx53TzwJ
        6GmeJEng3VPa0A7nAB7L4zcVy4Xzb/MBMIoBqgz1Q9sUxstRc8asMoyLpk30Ewoi
        XRd1Z4dgWXXoNyHSXUXYIOy0G7x4Q==
X-ME-Sender: <xms:7DL4YIEmdOrpftYnl1XZQJ9t6WB4DjW7Dteown09QjOJxUJrpHujHQ>
    <xme:7DL4YBVn7tKDgh_DniKcKC4PrYrSCHrs_aHZTW9mBwHvQpdBt-Dq-8jMo29eF60rr
    Ve4_SHZltVCA6eiQgc>
X-ME-Received: <xmr:7DL4YCIa2zSeuTNJFxXD9FZ0oEeNGuV2ZGiEaWgXntEWeoO6nP8hiwxdqEZSeGSR6sk1tlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeggdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtjeertddtfeejnecuhfhrohhmpeforghrthih
    nhgrshcurfhumhhpuhhtihhsuceomheslhgrmhgsuggrrdhltheqnecuggftrfgrthhtvg
    hrnheptdffkeelgeegheduieeiffefudefgfduuefhjefftddtteehveeludduteduffdv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmheslh
    grmhgsuggrrdhlth
X-ME-Proxy: <xmx:7DL4YKEYADM-Q23i8Jj7kTN5hg7tNCtBPji3WyDl178gyPFFRaRrOg>
    <xmx:7DL4YOXm2lvZGY3Ch3RVoOiDDoF9ZHWpdtzRNjMKKlvqt1mEOSuBvw>
    <xmx:7DL4YNOpqLmoP-46vFtkpzqzW82vZNWCKjnWI83bNOB7vROQ7GJ82g>
    <xmx:7TL4YNRWXy57P37yrCHKf6blQ5CRXel5LXBEfJ9mOQIdA11jteaUHg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jul 2021 10:44:58 -0400 (EDT)
Subject: Re: [PATCH iproute2] libbpf: fix attach of prog with multiple
 sections
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
References: <20210705124307.201303-1-m@lambda.lt>
 <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
From:   Martynas Pumputis <m@lambda.lt>
Message-ID: <df3396c3-9a4a-824d-648f-69f4da5bc78b@lambda.lt>
Date:   Wed, 21 Jul 2021 16:47:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAEf4Bzb_FAOMK+8J+wyvbR2etYFDU1ae=P3pwW3fzfcWctZ1Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/20/21 10:27 PM, Andrii Nakryiko wrote:
> On Mon, Jul 5, 2021 at 5:44 AM Martynas Pumputis <m@lambda.lt> wrote:
>>
>> When BPF programs which consists of multiple executable sections via
>> iproute2+libbpf (configured with LIBBPF_FORCE=on), we noticed that a
>> wrong section can be attached to a device. E.g.:
>>
>>      # tc qdisc replace dev lxc_health clsact
>>      # tc filter replace dev lxc_health ingress prio 1 \
>>          handle 1 bpf da obj bpf_lxc.o sec from-container
>>      # tc filter show dev lxc_health ingress filter protocol all
>>          pref 1 bpf chain 0 filter protocol all pref 1 bpf chain 0
>>          handle 0x1 bpf_lxc.o:[__send_drop_notify] <-- WRONG SECTION
>>          direct-action not_in_hw id 38 tag 7d891814eda6809e jited
>>
>> After taking a closer look into load_bpf_object() in lib/bpf_libbpf.c,
>> we noticed that the filter used in the program iterator does not check
>> whether a program section name matches a requested section name
>> (cfg->section). This can lead to a wrong prog FD being used to attach
>> the program.
>>
>> Fixes: 6d61a2b55799 ("lib: add libbpf support")
>> Signed-off-by: Martynas Pumputis <m@lambda.lt>
>> ---
>>   lib/bpf_libbpf.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
>> index d05737a4..f76b90d2 100644
>> --- a/lib/bpf_libbpf.c
>> +++ b/lib/bpf_libbpf.c
>> @@ -267,10 +267,12 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>          }
>>
>>          bpf_object__for_each_program(p, obj) {
>> +               bool prog_to_attach = !prog && cfg->section &&
>> +                       !strcmp(get_bpf_program__section_name(p), cfg->section);
> 
> This is still problematic, because one section can have multiple BPF
> programs. I.e., it's possible two define two or more XDP BPF programs
> all with SEC("xdp") and libbpf works just fine with that. I suggest
> moving users to specify the program name (i.e., C function name
> representing the BPF program). All the xdp_mycustom_suffix namings are
> a hack and will be rejected by libbpf 1.0, so it would be great to get
> a head start on fixing this early on.

Thanks for bringing this up. Currently, there is no way to specify a 
function name with "tc exec bpf" (only a section name via the "sec" 
arg). So probably, we should just add another arg to specify the 
function name.

It would be interesting to hear thoughts from iproute2 maintainers 
before fixing this.

> 
>> +
>>                  /* Only load the programs that will either be subsequently
>>                   * attached or inserted into a tail call map */
>> -               if (find_legacy_tail_calls(p, obj) < 0 && cfg->section &&
>> -                   strcmp(get_bpf_program__section_name(p), cfg->section)) {
>> +               if (find_legacy_tail_calls(p, obj) < 0 && !prog_to_attach) {
>>                          ret = bpf_program__set_autoload(p, false);
>>                          if (ret)
>>                                  return -EINVAL;
>> @@ -279,7 +281,8 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>>
>>                  bpf_program__set_type(p, cfg->type);
>>                  bpf_program__set_ifindex(p, cfg->ifindex);
>> -               if (!prog)
>> +
>> +               if (prog_to_attach)
>>                          prog = p;
>>          }
>>
>> --
>> 2.32.0
>>
