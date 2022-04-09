Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1C54FA7B2
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 14:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbiDIMjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 08:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiDIMjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 08:39:12 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEC338AA
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 05:37:04 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bh17so22127418ejb.8
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 05:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=ph+b6vEsWKwHnBUnlrg/LEJgtkhSmZYe3Lw1mNpS7CI=;
        b=7GuhuVtC3u8UnVwuZhUgtoEzCBmlt85sYwX+st0ZrgtcOnomUhTd6iDkv/nAUakm9x
         jtrUgk4JN3CAd+qFy2qeyTkjbSfyqNM8kRB2oChajlmgiKkeL5QtFKr9iDxUTfqYfXDt
         vZe+4AM6tUaHZotVlJsLR16vVLvPQj9n7EAY4h6xe9xzVrit711zhqpt6O5MD7ZrmWRQ
         oM/CTx7somdyGY4Ja7rJD0WfJivLe1s6G/1+J4M92MFHoeSGGUWU6cULMHDHeZXziRUF
         cMnWEEemDTKucMUmzaGmSNhKRKxjVaSOAmPXkmGIPvdnIG0Kk8v48LqC7eT9iOxWXyaG
         914g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=ph+b6vEsWKwHnBUnlrg/LEJgtkhSmZYe3Lw1mNpS7CI=;
        b=Wdu3tyPjDWQ+lu49VApW4MHegsvCT2ffnmvjBsd6YweEr/VgJm5+RKCoZ4sE1ubNwf
         8qOjliT0gVwsaVR3UG6HeqHwtjHn6ZKWFCXRoeFz4vwwi1qs85nQ1cDZ88BqbhODoUQq
         qz2X0casEffoC1gdRsmVe/fImLMsdeIpXzaVY3glLiYh/gsqTFT7iHoaynx2vZ5etulg
         namNOQVxEeUR9Ja/WsKMpuYooNH+DUuPVr6sXjcOzIpgCQFpVsprWxViEDKLioS5Rx33
         4yOhYcmc6L1IlGZnT+IPo8GbbZzUqp98PzVWaIC5ElF0RcaJd0RUllgwi/ThgivHGl/T
         2lSw==
X-Gm-Message-State: AOAM532PrbD/4o9e3YIeE78Rk5a5FGaOkCHijoavp71QixpBNfILxKMU
        +yaqeVD4wTqiL6W6R6FewdW8IzHVA898Sq8297Q=
X-Google-Smtp-Source: ABdhPJzKhEDLLc/H6WeUzFVkzWzt3OCdeGp8uq/bCJuBIOeUJoVZAbU5bjhDnpWhYHWjy/k46jfayg==
X-Received: by 2002:a17:906:c111:b0:6db:cf0e:3146 with SMTP id do17-20020a170906c11100b006dbcf0e3146mr22808993ejc.280.1649507823066;
        Sat, 09 Apr 2022 05:37:03 -0700 (PDT)
Received: from [127.0.0.1] ([46.249.67.250])
        by smtp.gmail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm11881167edz.35.2022.04.09.05.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Apr 2022 05:37:02 -0700 (PDT)
Date:   Sat, 09 Apr 2022 15:36:59 +0300
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
CC:     roopa@nvidia.com, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/6] net: bridge: add flush filtering support
User-Agent: K-9 Mail for Android
In-Reply-To: <20220409105857.803667-1-razor@blackwall.org>
References: <20220409105857.803667-1-razor@blackwall.org>
Message-ID: <133ACD1C-F64D-499B-BE66-4EDA3598A35C@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9 April 2022 13:58:51 EEST, Nikolay Aleksandrov <razor@blackwall=2Eorg> =
wrote:
>Hi,
>This patch-set adds support to specify filtering conditions for a flush
>operation=2E Initially only FDB flush filtering is added, later MDB
>support will be added as well=2E Some user-space applications need a way
>to delete only a specific set of entries, e=2Eg=2E mlag implementations n=
eed
>a way to flush only dynamic entries excluding externally learned ones
>or only externally learned ones without static entries etc=2E Also apps
>usually want to target only a specific vlan or port/vlan combination=2E
>The current 2 flush operations (per port and bridge-wide) are not
>extensible and cannot provide such filtering, so a new bridge af
>attribute is added (IFLA_BRIDGE_FLUSH) which contains the filtering
>information for each object type which has to be flushed=2E
>An example structure for fdbs:
>     [ IFLA_BRIDGE_FLUSH ]
>      `[ BRIDGE_FDB_FLUSH ]
>        `[ FDB_FLUSH_NDM_STATE ]
>        `[ FDB_FLUSH_NDM_FLAGS ]
>
>I decided against embedding these into the old flush attributes for
>multiple reasons - proper error handling on unsupported attributes,
>older kernels silently flushing all, need for a second mechanism to
>signal that the attribute should be parsed (e=2Eg=2E using boolopts),
>special treatment for permanent entries=2E
>
>Examples:
>$ bridge fdb flush dev bridge vlan 100 static
>< flush all static entries on vlan 100 >
>$ bridge fdb flush dev bridge vlan 1 dynamic
>< flush all dynamic entries on vlan 1 >
>$ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
>< flush all dynamic entries on port ens16 and vlan 1 >
>$ bridge fdb flush dev bridge nooffloaded nopermanent
>< flush all non-offloaded and non-permanent entries >
>$ bridge fdb flush dev bridge static noextern_learn
>< flush all static entries which are not externally learned >
>$ bridge fdb flush dev bridge permanent
>< flush all permanent entries >
>
>Note that all flags have their negated version (static vs nostatic etc)
>and there are some tricky cases to handle like "static" which in flag
>terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
>mask matches on both but we need only NUD_NOARP to be set=2E That's
>because permanent entries have both set so we can't just match on
>NUD_NOARP=2E Also note that this flush operation doesn't treat permanent
>entries in a special way (fdb_delete vs fdb_delete_local), it will
>delete them regardless if any port is using them=2E We can extend the api
>with a flag to do that if needed in the future=2E
>
>Patches in this set:
> 1=2E adds the new IFLA_BRIDGE_FLUSH bridge af attribute
> 2=2E adds a basic structure to describe an fdb flush filter
> 3=2E adds fdb netlink flush call via BRIDGE_FDB_FLUSH attribute
> 4 - 6=2E add support for specifying various fdb fields to filter
>
>Patch-sets (in order):
> - Initial flush infra and fdb flush filtering (this set)
> - iproute2 support
> - selftests
>
>Future work:
> - mdb flush support
>
>Thanks,
> Nik
>
>Nikolay Aleksandrov (6):
>  net: bridge: add a generic flush operation
>  net: bridge: fdb: add support for fine-grained flushing
>  net: bridge: fdb: add new nl attribute-based flush call
>  net: bridge: fdb: add support for flush filtering based on ndm flags
>    and state
>  net: bridge: fdb: add support for flush filtering based on ifindex
>  net: bridge: fdb: add support for flush filtering based on vlan id
>
> include/uapi/linux/if_bridge=2Eh |  22 ++++++
> net/bridge/br_fdb=2Ec            | 128 +++++++++++++++++++++++++++++++--
> net/bridge/br_netlink=2Ec        |  59 ++++++++++++++-
> net/bridge/br_private=2Eh        |  12 +++-
> net/bridge/br_sysfs_br=2Ec       |   6 +-
> 5 files changed, 215 insertions(+), 12 deletions(-)
>

Actually if you prefer I can send the selftests with this set, I'm used to=
 sending them last
after the iproute2 support is finalised=2E :)

Cheers,
  Nik
