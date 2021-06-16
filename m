Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2AE3AA062
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 17:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhFPPwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 11:52:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:19543 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234454AbhFPPwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 11:52:00 -0400
IronPort-SDR: Qee2uZOXdCkYSGTImffRBwDleIiQe+avTfQzxUiT3dG6hv2pABsiq19CD28UCmB6jBgqGI9pNF
 cAJrON8J53Uw==
X-IronPort-AV: E=McAfee;i="6200,9189,10016"; a="203179845"
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="gz'50?scan'50,208,50";a="203179845"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 08:49:53 -0700
IronPort-SDR: G2nIGDF/CKXOddeLWCjH+mCn5zVDbJ0L1z0jPz9zP2m3U1pjL1jEJtV/yUN6aBKL33WkGR+qR4
 hhUJQegAyU2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,278,1616482800"; 
   d="gz'50?scan'50,208,50";a="404614714"
Received: from lkp-server01.sh.intel.com (HELO 4aae0cb4f5b5) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 16 Jun 2021 08:49:50 -0700
Received: from kbuild by 4aae0cb4f5b5 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ltXnZ-0001IK-Ho; Wed, 16 Jun 2021 15:49:49 +0000
Date:   Wed, 16 Jun 2021 23:49:13 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tanner Love <tannerlove.kernel@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH net-next v6 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <202106162302.YDwoliRT-lkp@intel.com>
References: <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20210615001100.1008325-2-tannerlove.kernel@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Tanner,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Tanner-Love/virtio_net-add-optional-flow-dissection-in-virtio_net_hdr_to_skb/20210616-193224
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git c7654495916e109f76a67fd3ae68f8fa70ab4faa
config: um-x86_64_defconfig (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/7d159f648961a7849f67e1c3d7ecb3d18bf5c7c2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Tanner-Love/virtio_net-add-optional-flow-dissection-in-virtio_net_hdr_to_skb/20210616-193224
        git checkout 7d159f648961a7849f67e1c3d7ecb3d18bf5c7c2
        # save the attached .config to linux build tree
        make W=1 ARCH=um SUBARCH=x86_64

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> net/core/filter.c:8334:5: warning: no previous prototype for 'check_flow_keys_access' [-Wmissing-prototypes]
    8334 | int check_flow_keys_access(int off, int size, enum bpf_access_type t,
         |     ^~~~~~~~~~~~~~~~~~~~~~


vim +/check_flow_keys_access +8334 net/core/filter.c

  8333	
> 8334	int check_flow_keys_access(int off, int size, enum bpf_access_type t,
  8335				   struct bpf_insn_access_aux *info)
  8336	{
  8337		if (size < 0 || off < 0 ||
  8338		    (u64)off + size > sizeof(struct bpf_flow_keys))
  8339			return -EACCES;
  8340	
  8341		switch (off) {
  8342		case bpf_ctx_range_ptr(struct bpf_flow_keys, vhdr):
  8343			if (t == BPF_WRITE || off % size != 0 || size != sizeof(__u64))
  8344				return -EACCES;
  8345	
  8346			if (!bpf_flow_dissector_btf_ids[0])
  8347				return -EINVAL;
  8348	
  8349			info->btf_id = bpf_flow_dissector_btf_ids[0];
  8350	
  8351			break;
  8352		case offsetof(struct bpf_flow_keys, vhdr_is_little_endian):
  8353			if (t == BPF_WRITE)
  8354				return -EACCES;
  8355	
  8356			break;
  8357		}
  8358	
  8359		return 0;
  8360	}
  8361	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--wRRV7LY7NUeQGEoC
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICOoWymAAAy5jb25maWcAnFxLc9u4k7//PwUrc5mp2iSOnaSS3fIBIkERI75MgJLsC0uR
mEQ1tuWV5JnJt99u8AWQDSe1F1tCN96N7l83GvrtP7957Pl8eNic99vN/f0P71v9WB8353rn
fd3f1//jBZmXZsrjgVBvgDnePz7/+/b5wfvw5t3Vm4vXx+2Vt6iPj/W95x8ev+6/PUPl/eHx
P7/9x8/SUMwr36+WvJAiSyvF1+r61bft9vVn7/eg/rLfPHqf32Azl5d/NJ9eGdWErOa+f/2j
K5oPTV1/vri6uOh5Y5bOe1JfzKRuIi2HJqCoY7u8+nBx2ZXHAbLOwmBghSKa1SBcGKP1WVrF
Il0MLRiFlVRMCd+iRTAYJpNqnqmMJIgUqvKBJIqbapUV2AMs72/eXG/VvXeqz89Pw4LPimzB
0wrWWya5UTsVquLpsmIFTEIkQl2/u/zUzyrzWdxN69UrqrhipTnQWSlgJSSLlcEf8JCVsdKd
EcVRJlXKEn796vfHw2P9R88gV8wYqryVS5H7kwL876t4KM8zKdZVclPyktOlQ5XfvJa8YsqP
Kk319ifv8XDGFezXv8ikrBKeZMVtxZRifmRWLiWPxcys15NYCWeEaDFiSw6LDn1qDhwQi+Nu
E2FTvdPzl9OP07l+GDZxzlNeCF/vuYyylR5D/bjzDl9HVcY1fNizBV/yVMmuD7V/qI8nqhuQ
yQVICocu1LCAaVZFd5WfJQkIgzF5KMyhjywQPjHPppYIYj5qafgaiXlUFVxCvwkIlTmpyRh7
OcvDbh7w0ZpEPzAgVO262lvTNm5X7OWk4DzJFQxSn7Kmwbx8qzanv7wzjMfbQPXTeXM+eZvt
9vD8eN4/fhstHlSomO9nZapEOjeOhwygg8znIE1AV+Y6jmnV8oqUKMXkAhWHJKm5FORkf2EK
eqqFX3qSEon0tgKaOWD4WvE17D0l37JhNqvLrn47JLurXiMtmg+Gjlr0W5P55gDEIuIsAJEh
+o8zVEYgAJEIQae9H7ZXpAo0Lwv5mOeqWQG5/V7vnu/ro/e13pyfj/VJF7eDJqgjJQ3tgwo1
dPe8yMpcmgMHReLPiUHP4kXLPq5eST/ihh0KmSgqm9K37odgtFgarESgIlJICmXWJVnabnMR
0HLW0osgYZS+bKghnKU7XkwmE/Cl8PmkGGR0fChaSiKk/9IwAj4rqQVFsyJzBmdq6KxUskqN
72hCUjlS5wUU0edLBCNS1xVXo2Zgbf1FnoE8oHZTWcHJFvUeaDOq50KdpVsJWxpwUE0+U/Zm
j2nV8pLech6zW5KCQgcboq1zQQvDLMtU1Xymd8Gvshy0t7jjVZgVaA/gX8JSnzSmI24JHyyr
bllzbShLEbz7aE7bqXc6zu6kAcAQuJ9WB7Big8HtTlQERyaeAIbeJln6wwQ8hqbicQjLVBiN
zJiESZZWRyUg3tFXEKvRjJtiP8nXfmT2kGdmW1LMUxabAFWP1yzQRt8skBGoHwP8CgO+iawq
C8tisWApJO+Wy1gIaGTGikKYS7tAltvEOgVdWTUyw2OyXimUUiWWfHwaNVAMaeGEcfAgsNWY
1titB5LXx6+H48PmcVt7/O/6EYweA13uo9kDcGEq91+s0Y19mTSrW2lDb4kJwKScKUDdhqjI
mM2soxuXM+q0AxusbjHnHUK2KwEV9WosJOgVkNksodWKxRixIgAoSK+gjMowjHmVM+gT9gPg
PWgrWv0VWSjAAZmTIMP2PfTKlkn8+vRUb/df91vv8IRe4GmAFUA1JCoxEANgRJFZgqoK0OMI
fcOYzeEAl3meFQY+RYQLenBKALDkL5raE1qPjxkA+AIUKKw5KErjMN5dvxt8yrRAIyWv3zWT
iw6ns/d0PGzr0+lw9M4/nhpoZQGHbnaLT+SKJrnDtCWoSWhlnsD+JITo9LPJjZVcf/qImIQX
aRZwmCiYmxbxfDRZ4ndumpK+3V6rlz6+HxdnS7skAauSlIkGxCFLRHx7/bHHYoJdXVYhh3Ni
aXzkhY3SgyaKWRJMC6PbufZKRsU+nE5WFlPCXcSytUhNOPrTzTSEFuc2NPrx/Uwoe97mylxV
MaiJuMrnis1iE4p0+xWtOPhA9jnXoQEdJqDQLfjYfiHATQlujWmjJx2aOhr+y8w0agmbC+0x
FzeG2gbZgPHpc1JloCiK60tD2BKWg7ElRtFOqJmevL4ydDYsEVoiPLQ49fbckUqD1BCd7vD8
75vjZgtq1wvqv/fb2lAeUsFIi2oyRykNqUnB9gISY8Yq4UjGRep2VKImJWs4QsmoDP5VAHCz
pvjV191/X/wX/Hn3ymRoaE/n0ytjhEQpLpoESxJcP/SMxNcKQxE2ysB9xzBCBqzmuhKr1y9s
Wp//ORz/mi4rDgPArAGYm4KKqwgwlxmS6SgKzB9VLmNBlAaMj0IIHWXJfZfh6VkCClJ21MRn
UlEt5z6jkLUx0CI3lQG1QkOrS1EohEoJhWh0UEeWMuewVwAipZhZ0tlQJgVTZylPYFyc5+Z8
oAw9BV1OG+ikWrEFR2NIeSl5Mmpt4jkNEbEbGP0KPCEehsIXiHNaPDJBWp3d3xy33/fneov6
8vWufoLFBPQ0Nft+wWQ0kmEJ22DqLo2CtWYFSAIwF30kH4MjIxaMiSZZ0IYjJ1S9GdxHPPYC
qQJQoywnYVxlwjho6pbSWE+XJxqrrAspmYNASRpFi9AqGAo7C0qwGYiCtXuBCNlyMhugeXWJ
C4Uq1yWRAKja0JYB7pHA84gD3GQxGFxACH18cO5ny9dfNqd65/3V4GIwjl/39020a8B8L7BZ
U8VAfR6Xc5FaIb5flJ2uKViuBF0j04xq10Em6M5djNbNirroInQ5fYz9sIBYqpanTJHurNyQ
aWg2iKKLju3Iwu8D6OPw5IhTUOLUEnH3CwwYtqI1rtzT53eC1hdjxvXdL7HdgfF9iRG9iBWG
bSRKdB+GqUSC1pfSTFARnIsZeiEqun719vRl//j24bADafpS9zZyhorNipq20YuZpLWYQXeF
6IcAiOLzQqiXwyR3mcuN6jhUVGRKTZ0kg81PArzFgbkWktMGD9lWM+Vuool8iQw8Zp767kH3
jD6gBCeXBP2a5YwWRWRo7p0q6Kq4zcH6pRMrkG+O5z2eVk8BdracH5inEkpLe7DEsBB59mSQ
yYHVCGGEwirudce4RzOOqi1dc5mSDVFbwwglN7AmTfAt4Cywb9UM4uJ2ZlqGrngW3mi01XUZ
3lTdQhNR1e6SxhpK32SztDIXqVYtgMKFic9begGjbOkv0ci6K5Br7qpsEu3aAybRK8n/rbfP
582X+1rfA3s6SnI21nQm0jBRaKisoJht6fFbFZRJ3t8AomFrQ/mGVm/aavycSTFGhAdgjE1i
i6ZwuAarZ5LUD4fjDy/ZPG6+1Q8kSAnhYFkBCCyotBMNxeBJmeggj8H85kqvoI4QvB+ZaH98
ZIyzMcf9Q704UhkdQ3Qr4dwERaV6V3MIr0kqENAtLPpu6IPr6tfvLz73bn3KQYbBrdPgY2Gh
Qj/mcEQRzZDjDYssVXg1S4eC7fuAvvwuzzJaudzNSlqf3mmTntHREbxRbJYOIzsLl7KFGWqX
f3xf1iAcOK2Kg1J8rOvdyTsfvO+bv2tPQzjAoiBIKD07E+245WZYWNUdl9aBACQ0lS6QiAW3
drIpqQLBKCEoU2EEjfEbnAxr23TZuPZwaxjTeGQdglNbuowQ+kYLfkuMR6T26EXexNrRAaM3
LO91fwV6Ujl6BLY8pUULByNyB45piHPULDwp13Sc8xac8SxbCE6vRdPGUgknNcxKetRIZPRl
m6YB/HETRY4qwrHIektNlY3+tp93xXZLZZC7RUBzFGz1Ew6kwiJKVWQ0qMDe4eP8JVve8/jl
zMxw6RRTR79+tX3+st++sltPgg/ScdUE+/PREUeFmq6NwwQZdNQSVixe5AFdq70oUBhJ7lIq
wNy4gTRYyl8ggngHvmOcAu9jFU0rHNewCmSHzjtR9LVAfOnoYVaIYE5rfC0Vktbry5il1aeL
y3c3JDngPtSmRxL7dHSbKRbTu7S+/EA3xXIa2udR5upecM5x3B/eO+fsvh0PfIcrAcvONMgl
yVnO06VcCeXTqmIpMUvHkdkBI9JJY87Tm+QOHd9cTdNdRtKt+ZuRgkvj5IivAAdJEPbKxXVT
KHcHqT/OVulQRAOldeSuAND8Ex4/ZuBoUnpIq7x1NSvlbWVfnc5u4pGd9s716dxFN4z6+ULN
+Qi7tXBgUnNEME2/seYsKVjgmhajYaLDFWQhzK9wKYGwWvgUPlyJgsdNLG3oOJzjeXg3gUk9
oYdJX+oOGyGq9hLmawbDt2pLEHhhUkwEJevmov/CUGrhQjiCH7junx0Ik4mQJvA8qlxOfhrS
S5RLUPSxW++JkKbFK1WmKadHHzIRZ0vyzoSrSAES7k5zJ4JNjNkLjvu/Gyd1iKvut22xl/Ug
cgB9zQV0xGP6igaOpUpyM67alVQJxhutW9I0YLEVosyLpvlQFMmKAbbS6Z3dmMP98eGfzbH2
7g+bXX00PKeVDq+ZXjNfA0zv28Ek0GGxOu4m72Y6FYKzi0MRMwYm7buYruB4pH38U0epMGZj
OZD9SqEfEBRi6RhPy8CXhQNQNgzoYrTNgJ+XgGDQphzZGGBUv2PW8bCXr3nbVKppRHUqNU2y
5PPJ2/U3PoPpiATqSFLHmVVMpxak33lbM0+lI/zpCBtmITHPNqBGhfv0td4spu5GO5ZyFlA1
oRgdASpXtWPxQSj6PNcRLc6yfIg7mKXaz9ZB/OtP02511CxDvhdjh0Exo8xYP+1ZYAWd2uKC
0WAPkFSFegi1zovdjnptrOIy4Z58fno6HM+mC2yVN8GU/WlLSRUcqOQWA0pk3zz140yWoFXg
2GshprX65fjmuAlFcTgdiXcyxte1qynV5yt//ZEU6FHVJhm6/ndz8sTj6Xx8ftAZP6fvoDB2
3vm4eTwhn3e/f6y9HUx1/4QfzSX5f9TW1dn9uT5uvDCfM+9rp6N2h38eUU95DweME3q/H+v/
fd4fa+jg0v/Dmqkf0RgiX+YsFT45e2uzmoRXRGFNibGenVkAIsbmzaNUMBFgFnxB75icoLou
d5boyFANtGZQrJgjxBulTw4metCAhtluI46DoGdpQEfXtJCahwqx0bxkjlRIflOyGHCMG9Qq
7jiNAIrQW3K5tS7Scu2ioB1wGJMZWNkyoHXN3OEBwvjARXbNy2/SLChfv0zN9YOv1VLvgX40
4cBWS5dKSuPEDpQOwAnTVJS9zwBPgqwAQ858DGLrZxkEOWF3pjI3SbCfqRKMJhY+We6zpSgT
mqTDuHRz/M6PzIQIgzTPsrn1RGIgRSVbcUGSxKfLD+s1TbKTpwxKInBjspBeyYQVSx6/UNM5
haZdntBDTZly07gqsjRL6PmndKVPV58vSAL42BLTIkkinl407ZY6S0Yxgmm1Ak6aZJJsskCf
vSBJ4FvI0symNWlZzIowZgU9a5n5ArD4mt4lADBZLm/pAS0d0rzGxM21FXKObl3+UgL+aQsu
J7Y392Wnxne9wzJcyk2pvT+R56amgK/46mUc/LToAcdrF1qHIP2FWBuSkzx319UB63GGncmR
ueuyMYa0qBrFK0UFznVO1JDRFUe+uSRI7b0bV7ou8kg4qHREQJMTvKbCTx8nu4d5jq9P+13t
lXLW2WHNBe5969EjpYttsN3mCTPIJtBgFZupcPit15tBovjCQVPW0zn46syZsaslpj4zSbMC
nEJYM5rqC+lnNGmkI8ekQgrriaDOsqPC9GbFif60iDwQzLkyhHo1yQWzH5JaNM5iZ7swD5og
FV2uHPx3t4GpA02StqI8Ta3cpBWbJgmsAMne16eTB0QTy65WY5DTqhOrgo20qDDLwLBMJp0P
6ZC7cdYjHFb7eu3zJ8wKNaYb8znzb52Fret3ZbweBsnT2XrjXKK0mksaImq3VjkyUMBNEixu
slnGvnqHqprERDdWi1btmwE7LXNcBn00V98G5l+RoZDueeFkZc2q2HililIq/ZSoCeJMdgfc
G8qfw2KqS5Pd4L6itbLMEzrUHDlC0Hk+vTDOATlv7w/bv6hxArF69+HTp+at7dRh1QFTrzW5
mFjuvHM6H6Ba7Z2/195mt9MJLpv7puPTG8vUTsZjDEekviro+OQ8F5nL8Dc5n2B+HPcmDR0T
umPH9SDg9MSRSKRfWQcZfX+BblfsfHmidWflc59KJm+ipcfN0/f99mRtThcTG9N6A2ylVGPE
04+ZMI+HnFVZ5IsqFkrFmAAF47Cyl+GkSHz16/CcVqAkHLd3TUKrmAEIcZz5QvnN7cZktkHC
ZmVoJBYMoo7gA3ARDV6aehWGIas0UyKkO27Z3OnBLUPEWU7HDUcDNGZdrkE15q73iKXjYmQZ
ugiYQ9voJiog3OrEhKfW6+VlkFMvV5do5afMutR1ldhQG3e3EY/WLkw2Ldlvj4fT4evZi348
1cfXS+/bc306UxL7M1bjNBf81mUQABbBuaE1omJz1w13E/0EyaOFOlphrhqp5nytjuTh+Uh7
ByTdjEGIeJatiY0RMKTSeMBlXZBoopdvvtVNwhcRtvwZa/P6vX44nGt8BESNnaA2tZ4eTt/I
ChahCbZlvve71E/evewR7Ob+6Q+vf/4yuv9hD/eHb1AsDz7VPEVuovzHw2a3PTy4KpL0Jui7
zt+Gx7o+bTewNjeHo7hxNfIzVs27f5OsXQ1MaKadjPfnuqHOnvf3O/Q/ukUimvr1SrrWzfPm
HqbvXB+SbpycDJw7MRH9NSa9/+tqk6L2gdFfEgrDBuO7jWVYcEdkfY3ROocVxZ8woUOQDvWa
r6ZAGmP6WxglpbgmNNPCSx2bTVWRxTEBAQEKWb8+YYU68coLGShjY1ccoRXfkatYsKlZZY+7
42G/M/sG+Fpkgk7o7dgNu8jo5DO8NpkuZLTCO4It5gkQkFKOk3i6p4rTWkMlfZtAXzA6foBA
ZI58uVgkLsOiHWS/uQR0mBD9JpqGBvZtd3ubDAe42T8LzSzB7Q3wYW4oiXT5bs4S7QOzrm/h
FFxiFqfjhFyNaAPlvfUOSRfg6xv8qQJsc9THez0w/VsBzKdRb8cluV863xdoJlck5M9ZYPWL
353MeLc/6+7A+5Mn8Bm9bKZmHMi2WP9WhQOVtyz46yuw7SGtJYwOqjXeDZFcf2oGkrR2k+ah
dO7kTBXuiqmIX6gaXrpr4m9qMAqG8DXiD3sVu7LmdUqV5WRegsCXsplOVTbeGWDShcJflRrR
zZHQby5MDoC+gow2hrLB+IZrPy4QTUHV/krG0Cybugct6abMlBXp0QV9hprWDSEjf/xD/35G
y79iRTqabUNwex03mPu/fPcC7dI1XuuNOYZlQqlP+oNd1hQNq6CPPi0kGHsCL2ZEbpTXZvvd
vgwPJZFS34HihrthD14XWfI2WAZaJQ4asdsumX3++PHCGvmf4M3b6dh3wOYYdRmEkwl146D7
bvzNTL4NmXrL1/g3VaPRDQhDv+Jx9L2Eum6d/AIxVcRZ7azJSyNrYMWpft4d9DOQyXpqtRZa
v/ACBQv7yYoum/zOHBbqJwjgKwk4xNbVChL9SMT/V9m1NSeOK+G/Qs3TOVWZqZB7HubB2CJ4
MDbIdgjzQhHiTahJgAKyZ3N+/VG35ItstexTtbuzQ3+WdVer3f21x5npcybE3Fffiqw05V9z
p63y8EafLfs5IzH07ivlGOV5c2Wok1BQhp64xzJx3GqegfgHPQCG7i2KBBsobG2ifQnTmWEi
7oQPjN6DHc8iG9KykVU0DVJSPLDUZkCLLE+53JkQoniWOvGIWiiW4xA4NZ7IPWliaf2Uls3C
pyur9IaWcttLpxbmq0X8SD2WWrqbRw1hvk0okyox40KLqjCMCSI08CqlRtenBJHn0FOXqnyV
Xkn8paD/+bY57u7uru+/9ytukwAQr2G4AV1d3ppbVQXddgLdml3sNdDd9XkXkNm9vwbq9LoO
Fb+76VKnG7PqUAN1qfiNmZ2xBiKCC3RQly64MUe91ED37aD7yw4l3XcZ4PvLDv10f9WhTne3
dD8JRQbm/tLMnqQV07/oUm2BoieBE7s+Ef5VqQv9fI6geyZH0NMnR7T3CT1xcgQ91jmCXlo5
gh7Aoj/aG9Nvb02fbs448u+WxHfeXGyOzAPxxHHhjCK86HKEyyB8sQUibjYpN9+ACxCPnMRv
e9mC+0HQ8roHh7VCOGPEhyeF8EW7xCXTjglT32zF0bqvrVFJysc+EWcEmDQZmldxGvqwPA1n
oh8t5zPdlb9iJpIW9Wz9edicvkyfwsZsQShfyhSz9CYsRsNkwn3CkmU12+RC44mOvCc59R5e
sN1ouigp9jTvkjrM/DpJCwYYcPGxxH3IOMuynU7FlTGIJz+/va+2L/Ax5gz+A07HZ1+rj9UZ
uB7vN9uz4+qvTBS4eTnbbE/ZK/Tw2fP+r28at+Lb6vCSbfUA52p8/Wa7OW1W75v/1ujfkXZc
8o3VmUtQJGlRxA0qbwdh+sjBwFNAYvXQ7XqVatyPhhYVVvr6RMtbI337829S7uFrf9r11rtD
1tsdem/Z+74aHCPBonkPTpX0U/v5ovE7xFAZf9TMgup3sVTFQWfeLhWkHvFtLGDp+TESvEFo
Smx4Ebir2N6CfxBqtWpvmowY4UinIBihX7evTD+f3zfr73+yr94a+/sVPvB/Vde+epwTgatK
7Jm3KyVlbqvcXjxzeQsinph1hbwLU/7ILq6v+/eNPnA+T2/ZFlI0QGIGtsWOADKU/2xObz3n
eNytNyjyVqeVoWdc1+yEpMQPdrE7csQ/F+fTKFj0L8/NZ3c+yuzBj/sX5s0/7wc2880hpEVX
jhyx3h8b/TDAT8ofuxfd4JbXc2CdXe7Q7AaTiwlTSiGmrv2qytbCAz63iSN71aYtLXuy100c
jXNOkXioYQNXhiS1TgPwX2kOyWh1fKNHROgKtiJHLfKnloY/1p6X5svNa3Y8NbZhl7uXF65h
a0OBtRZPsP3aEIPAGbML6xhKiHWcREWS/rlHxbyqtdpWly6rdOKZdfRCbH/aF+uTBfCnDcYn
Xp+4qecbwcgx369K+cW1+V5TIq771sETCPOVpdiU7eJE6BsDwo1NYebTWh3kStjs33LHgPoe
aZ0GDubHsM+laD6k1O98MjkTJq4d1gMJGFysIw0Aa/979qYM8c8uZ4v9vOBTcR2zj6J1Qifz
qK2/FERR+jZHc/exP2THo9Rtm91Ahy7kJ8BvggRAiu+urLM4+G1tnxCPrGuxTuInnZnEtWD3
0Qs/P56zg2JnPJkb6ISxv3SnnHIiU93ABw/oUGcD/fKThHEGjiHEzaeiuC6Firxs2/EKYDx2
/emoXR1GcEtbCpzDnGbXKc3/ffN8WImbxmH3edpsjUdg4A+67P0Ak2uhFWVUE5u4/ByAoIDf
7CdwNhhK63JalHUz64C1M31eXI+ywwncmoRmesRYk+PmdYsM2731W7b+U6MX7QJHfGDp9WmT
IUxJBn4CHAc8rnzsy32NkFAp8QMDYffQB8Jen4NDu87H5ka8lgiprAUHRuwwnQwYETkrznqh
lYulYOxIV0+BAWCrZuAu/SRdEmVd1i6O4gexpQbD+m1LBwS+ywaLO8OjUkLtRwhx+JzeDgEx
IIxQQkoY0oWEFJgNm2LaSp2Pesx8SZExDEQfFain30B4ZOi+MAJ/6Yr7ARDvil9IWj+UiX2G
8vHxZtUQzQA++WpGFD5DuhvDk7F4U81TCmxf4QPRNLUOG8tLNwPl6xZ/3R8229MfjHF4+ciO
rybLnMrDVGcsrssh6YjZUiFDXCCHk2TXzz+W3ZKIWQpOElfl1+44hu8BjRKuylpg4htVFY/M
oOMtQkeovTZn+SqCimWPF5NBJNbRknGO+fAq4TjwmPhX7FSDKNa4TcjOLjSUzXv2HbN+4YZ5
ROha/n4wDY18W93TSwmHXNQMPXd+9s8vrvRJNEU2bkjnYl5E4tBEe5JDkFbCe2OGVJngOTCB
aJGKi0RNgrVYRmFQcWaS1cOkS7o3kyJ1RPrmOXPGOfelcbJ37jXNCV0tBi97/nx9BQtihRCi
So1UZGAo+U9D6Jaf5//0TSgZ91X1GavLwHiSstDViXUKHkujyX0QEwF3nZqjj5lMIFGfr0jR
+qXZg4vC9NNZrEL2lLAwplzcZIEApBlBsZhoHlLRwCAWEyOOQirqQb4lGvxilF1HTdHAMSXu
QWu/6pAJmwRiljVnYC6xFY928RQ2J/M3AOQflihIHED7bsryHunFpjJaYmLO0ros89iNHTFD
co2nIQU3C6T2jgTKTyCXF5xlOaeYbnMvh73R1lGNHkaxYQl8L9rtj2e9YLf+87mX62+02r7W
FLtQLAWxJ0Rmp0tNDq7EKSsp4qUQTqAoTaq8ZECOAJ6YmFguoVmOpHA5SkOZldEIms/sUW9I
+yTfZlyO9r6QX8CKnITV9aXNFuxt7cyHnw1pJBtpDumxg54bM1anyZTaOJhky63jX8f9Zovx
i2e9j89T9k8m/ic7rX/8+PHvsqroPYtlP6A+UsT6VLQCCFtTXrJm/Q7KgHZZFkSZQ8C2Cg0R
TjVIeyHzuQSJLSOaA7G9rVbzmBEHpwRg0+j9rwRB5+HNVyl05kKxODG1E6BgIlXasgU2xTd2
h+1FubEnXzp3/MSkLOWq5v8xdxpai0oPZlKvijRgeow6x2+NyzSMGfOAnJjOqaa2cHlC2E8A
TVmrbGoqR8bL6rTqwXG6biQKU+PoE72ojsIWOZENQQrRr9unLqF4BoZLD8jDhKbKU4PnubY3
EU2qv9XlonuBakdnKZVGJzc16waQYxYyD1qmFUBa5x6AOBt2KovXPNc1KZvFlqmrt6OxG8yU
AsoNqqeu6uM6EToR0jWal69M+5BEJkYKaIO+heb6cWMBiBUjzruhbLb5nJNHiAUwmgM1vgUg
FdyS/RmRBKMxypZx6Ewh/7TJZiNWqND+ZSpC1nAgyH93QjHPMSWqfIDYqAs4EAragEWakMgy
ReJFmIxkVkhL82RS2IEYvxHJSK2S9fh4TYAoA3rzRQbT5qL6/DDpA8zhwaJMY1pMXQ1dvdwn
ktsWlQ5393d2WL1mmo9NGlLOQ2qfgQstcqr8YnQahDxFvAFTNZqgZupW0wwqhVSooeJnlSVy
qn3SA7yhPA75liZyN4DFUg/6lpoZZM+MG7nrqhDgfYQweBphf97zHwnz1qBMXAkpMuhtawAf
pCxySPYQR0EEQd0kCu/MQkde2gtTKRVIOeSm9N2bK7vGgC0fsScgXbV0nLRMSTcnYkEpXOwS
Hw4QMBaIhAhzRAAuCLMlFeXSakbL07QeIVqVPjmcE8YjlEMk0VCoiDSCw/cOTLdo6U7qkwhK
fY8KC4VpPjZrPHnbozrJQ1X+aMnTITsnRs5e2wANprbOD8RCGEV4gph9RNAgDynQ7Jsqlpaz
EFumE0b6WNpD2wLVdEQvPdL7UE7JSWSZMZAiXpyp1rWBXzWIvTcvxA5AvzmwjJhvgdYToOE4
J23A/wP6yuRRPYYAAA==

--wRRV7LY7NUeQGEoC--
