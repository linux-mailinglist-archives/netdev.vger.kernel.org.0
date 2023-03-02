Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559826A7A34
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 04:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCBDx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 22:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjCBDxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 22:53:23 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34773196B8;
        Wed,  1 Mar 2023 19:53:22 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id t4so2432592ybg.11;
        Wed, 01 Mar 2023 19:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677729201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olubbFCj2I9ZqjPA3Rticc6RmZiMmVoBPM0eS4bJWP0=;
        b=EmOSKEROBdt934bbNKEMUKIj/HI6XEus5Yilw7QAUasqhr10B5Nr+sU8unvonZHILk
         rNAfO/a4aGJNVUMZK+xxuqXe/bZp68t0kJkdd/2wZ2vsBbd3UBKEiF6x5QjxT22g3op/
         BXxO01Stxflg1RblCg2BSU60Kouq0Yp8khQFtLsuqXEWOJIVRzxoBfgENH12vxIch+9r
         MazPTciYAKImZF8fYMbmXXY/6h92CxNc2gKuCwzLr3atuv9No+ox6t1iWtJrGfULz2OU
         3cwsnD97MRZ532qDf123qeTXoTNPFzwJDBpZ8+6yML18oVwB8lW7AEKowROld/DNMmhS
         z1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677729201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olubbFCj2I9ZqjPA3Rticc6RmZiMmVoBPM0eS4bJWP0=;
        b=O96+IOV1adxsz5Pz1Sv2Zkf9+2HGtZgDwNhqWhTdJ/uSURZDzcwreuM6ni0BIXJx3f
         q5AeABt9Rqrck1D9zGeaZWgdcH6HtqdXH4mtPc2tnKclBRxNHTVze/LTE1SSel4H2HM8
         I5HWqj6zraKX0BmOW6KCFVyCRt79wDt/KtGW800qVBueWijd1KZTWG1UilC5qM+igPpV
         WCRWTnw4stsIt2KusBXm6LIxrm2oZetn/JzQaQQol4Z6xL5X3jAMhQ4truNcsY9IlmIv
         qu2RHXq6SvzX23p65X73ZPTsg120MZyuaVORZiSFRm2GrCeHvEa3sQm+K04iK+GCHhdm
         OWlQ==
X-Gm-Message-State: AO0yUKXp8L4UxDIScmPMEumk4jXMExg7DWOMmTpiHEjRtS+XMhlicLMU
        oIdYpdN6IWC1rgQNK7Sl354OOaF9XORnpeD8pWD4sQBh
X-Google-Smtp-Source: AK7set9mico0/sVjgKgDIQgvDaZig3QmtQRoC/gT8MCRlR88Hz9/Niy6rHJVBx5de5AN6cu/FZi7eOu6qCSxzzUx9mg=
X-Received: by 2002:a05:6902:185:b0:9fe:1493:8b9 with SMTP id
 t5-20020a056902018500b009fe149308b9mr2681776ybh.8.1677729201357; Wed, 01 Mar
 2023 19:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20230301154953.641654-10-joannelkoong@gmail.com> <202303021152.sPWiwGYn-lkp@intel.com>
In-Reply-To: <202303021152.sPWiwGYn-lkp@intel.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 1 Mar 2023 19:53:10 -0800
Message-ID: <CAJnrk1Zp=kN0KVF0tsAzdaDHVJ-vA2Z3zCiYU9v5JkGu51tx2w@mail.gmail.com>
Subject: Re: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
To:     kernel test robot <lkp@intel.com>
Cc:     bpf@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
        martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 1, 2023 at 7:30=E2=80=AFPM kernel test robot <lkp@intel.com> wr=
ote:
>
> Hi Joanne,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on bpf-next/master]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Joanne-Koong/bpf-S=
upport-sk_buff-and-xdp_buff-as-valid-kfunc-arg-types/20230301-235341
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git =
master
> patch link:    https://lore.kernel.org/r/20230301154953.641654-10-joannel=
koong%40gmail.com
> patch subject: [PATCH v13 bpf-next 09/10] bpf: Add bpf_dynptr_slice and b=
pf_dynptr_slice_rdwr
> config: microblaze-randconfig-s043-20230302 (https://download.01.org/0day=
-ci/archive/20230302/202303021152.sPWiwGYn-lkp@intel.com/config)
> compiler: microblaze-linux-gcc (GCC) 12.1.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbi=
n/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.4-39-gce1a6720-dirty
>         # https://github.com/intel-lab-lkp/linux/commit/ab021cad431168baa=
ba04ed320003be30f4deb34
>         git remote add linux-review https://github.com/intel-lab-lkp/linu=
x
>         git fetch --no-tags linux-review Joanne-Koong/bpf-Support-sk_buff=
-and-xdp_buff-as-valid-kfunc-arg-types/20230301-235341
>         git checkout ab021cad431168baaba04ed320003be30f4deb34
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss C=3D1 CF=3D'-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=3Dbuild_dir ARCH=
=3Dmicroblaze olddefconfig
>         COMPILER_INSTALL_PATH=3D$HOME/0day COMPILER=3Dgcc-12.1.0 make.cro=
ss C=3D1 CF=3D'-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=3Dbuild_dir ARCH=
=3Dmicroblaze SHELL=3D/bin/bash kernel/bpf/
>
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202303021152.sPWiwGYn-lkp@i=
ntel.com/
>
> sparse warnings: (new ones prefixed by >>)
> >> kernel/bpf/helpers.c:2231:24: sparse: sparse: Using plain integer as N=
ULL pointer
>    kernel/bpf/helpers.c:2235:24: sparse: sparse: Using plain integer as N=
ULL pointer
>    kernel/bpf/helpers.c:2256:24: sparse: sparse: Using plain integer as N=
ULL pointer
>    kernel/bpf/helpers.c:2305:24: sparse: sparse: Using plain integer as N=
ULL pointer

Argh, sorry about that. I'll submit a follow-up for returning NULL
instead of 0.

>    kernel/bpf/helpers.c:2342:18: sparse: sparse: context imbalance in 'bp=
f_rcu_read_lock' - wrong count at exit
>    kernel/bpf/helpers.c:2347:18: sparse: sparse: context imbalance in 'bp=
f_rcu_read_unlock' - unexpected unlock
>
> vim +2231 kernel/bpf/helpers.c
>
>   2195
>   2196  /**
>   2197   * bpf_dynptr_slice - Obtain a read-only pointer to the dynptr da=
ta.
>   2198   *
>   2199   * For non-skb and non-xdp type dynptrs, there is no difference b=
etween
>   2200   * bpf_dynptr_slice and bpf_dynptr_data.
>   2201   *
>   2202   * If the intention is to write to the data slice, please use
>   2203   * bpf_dynptr_slice_rdwr.
>   2204   *
>   2205   * The user must check that the returned pointer is not null befo=
re using it.
>   2206   *
>   2207   * Please note that in the case of skb and xdp dynptrs, bpf_dynpt=
r_slice
>   2208   * does not change the underlying packet data pointers, so a call=
 to
>   2209   * bpf_dynptr_slice will not invalidate any ctx->data/data_end po=
inters in
>   2210   * the bpf program.
>   2211   *
>   2212   * @ptr: The dynptr whose data slice to retrieve
>   2213   * @offset: Offset into the dynptr
>   2214   * @buffer: User-provided buffer to copy contents into
>   2215   * @buffer__szk: Size (in bytes) of the buffer. This is the lengt=
h of the
>   2216   * requested slice. This must be a constant.
>   2217   *
>   2218   * @returns: NULL if the call failed (eg invalid dynptr), pointer=
 to a read-only
>   2219   * data slice (can be either direct pointer to the data or a poin=
ter to the user
>   2220   * provided buffer, with its contents containing the data, if una=
ble to obtain
>   2221   * direct pointer)
>   2222   */
>   2223  __bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *=
ptr, u32 offset,
>   2224                                     void *buffer, u32 buffer__szk)
>   2225  {
>   2226          enum bpf_dynptr_type type;
>   2227          u32 len =3D buffer__szk;
>   2228          int err;
>   2229
>   2230          if (!ptr->data)
> > 2231                  return 0;
>   2232
>   2233          err =3D bpf_dynptr_check_off_len(ptr, offset, len);
>   2234          if (err)
>   2235                  return 0;
>   2236
>   2237          type =3D bpf_dynptr_get_type(ptr);
>   2238
>   2239          switch (type) {
>   2240          case BPF_DYNPTR_TYPE_LOCAL:
>   2241          case BPF_DYNPTR_TYPE_RINGBUF:
>   2242                  return ptr->data + ptr->offset + offset;
>   2243          case BPF_DYNPTR_TYPE_SKB:
>   2244                  return skb_header_pointer(ptr->data, ptr->offset =
+ offset, len, buffer);
>   2245          case BPF_DYNPTR_TYPE_XDP:
>   2246          {
>   2247                  void *xdp_ptr =3D bpf_xdp_pointer(ptr->data, ptr-=
>offset + offset, len);
>   2248                  if (xdp_ptr)
>   2249                          return xdp_ptr;
>   2250
>   2251                  bpf_xdp_copy_buf(ptr->data, ptr->offset + offset,=
 buffer, len, false);
>   2252                  return buffer;
>   2253          }
>   2254          default:
>   2255                  WARN_ONCE(true, "unknown dynptr type %d\n", type)=
;
>   2256                  return 0;
>   2257          }
>   2258  }
>   2259
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests
